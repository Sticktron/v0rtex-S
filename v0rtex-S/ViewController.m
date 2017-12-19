//
//  ViewController.m
//  v0rtex
//
//  Created by Sticktron on 2017-12-07.
//  Copyright © 2017 Sticktron. All rights reserved.
//

#import "ViewController.h"
#import "v0rtex.h"
#import "common.h"

#include <sys/utsname.h>
#include <pthread.h>
#import <spawn.h>


ViewController *controller;

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextView *outputView;
@property (weak, nonatomic) IBOutlet UIButton *sploitButton;
@property (weak, nonatomic) IBOutlet UIButton *panicButton;
@end


//typedef kern_return_t (*v0rtex_cb_t)(task_t tfp0, kptr_t kbase, void *data);
kern_return_t post_jb(task_t tfp0, kptr_t kbase, void *data) {
    LOG("> post_jb callback");
    
    controller.sploitButton.enabled = NO;

    LOG("* got tfp0 -> %x", tfp0);
    
    uint64_t kslide = kbase - 0xfffffff007004000;
    LOG("* slide = 0x%llx", kslide);
    
    
    // print kernel magic
    extern kern_return_t mach_vm_read_overwrite(vm_map_t target_task, mach_vm_address_t address, mach_vm_size_t size, mach_vm_address_t data, mach_vm_size_t *outsize);
    uint32_t magic = 0;
    mach_vm_size_t sz = sizeof(magic);
    mach_vm_read_overwrite(tfp0, 0xfffffff007004000 + kslide, sizeof(magic), (mach_vm_address_t)&magic, &sz);
//    LOG("mach_vm_read_overwrite: %x, %s", magic, mach_error_string(ret));
    LOG("found kernel magic: %x", magic);
    
    
    // write a test file
    LOG("> writing test file...");
    FILE *f = fopen("/var/mobile/test.txt", "w");
    if (f == 0) {
        LOG("ERROR: failed to write test file");
        goto out;
    }
    LOG("wrote /var/mobile/test.txt (%p)", f);
    
    
    // enable panic button
//    prepare_rwk_via_tfp0(tfp0);
//    self.panicButton.enabled = YES;
    
    
out:;
    LOG("post_jb() done. \n");
    return 0;
}

void* bg(void *arg) {
    LOG("> exploiting kernel...");
    
    kern_return_t ret = v0rtex(post_jb, NULL);
    if (ret != KERN_SUCCESS) {
        LOG("ERROR: exploit failed");
        goto out;
    }
    
out:;
    LOG("bg() done. \n");
    return NULL;
}


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.sploitButton.layer.cornerRadius = 8;
    [self.sploitButton setTitleColor:self.view.backgroundColor forState:UIControlStateDisabled];

    self.outputView.layer.cornerRadius = 6;
    self.outputView.text = @"";
    
    self.panicButton.enabled = NO;
    [self.panicButton setTitleColor:self.view.backgroundColor forState:UIControlStateDisabled];
    
    
    // get kernel info
    struct utsname u = { 0 };
    uname(&u);
    [self log:[NSString stringWithFormat:@"%s \n\n", u.version]];
    
    // already jailbroken?
    if (strstr(u.version, "MarijuanARM")) {
        self.sploitButton.enabled = NO;
        [self.sploitButton setTitle:@"already jailbroken" forState:UIControlStateDisabled];
        [self log:@"Already jailbroke god. \n\n"];
        return;
    }
    
    // store a global ref to ourself
    controller = self;
    
    [self log:@"Ready. \n"];
}

- (IBAction)runSploit:(UIButton *)sender {
    [self log:@"> entering the v0rtex... \n"];
    
    // run v0rtex on a background thread
    pthread_t th;
    pthread_create(&th, NULL, &bg, NULL);
    
    [self log:@"runSploit: done \n"];
}

- (void)log:(NSString *)message {
    if (message && self.outputView) {
        self.outputView.text = [self.outputView.text stringByAppendingString:message];
    }
}

- (IBAction)panic:(UIButton *)sender {
    NSLog(@"PANIC!");
//    for (int i = 0; i<0xff; i++) {
//        rk64(0xFFFFFFF007004000 + i*0x100000);
//    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
