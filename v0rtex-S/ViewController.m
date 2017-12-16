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

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextView *outputView;
@property (weak, nonatomic) IBOutlet UIButton *sploitButton;
@end

@implementation ViewController

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

    task_t tfp0 = MACH_PORT_NULL;
    kptr_t kslide = 0;
    
    kern_return_t v0rtex(task_t *tfp0, kptr_t *kslide);
    kern_return_t ret = v0rtex(&tfp0, &kslide);
    
    if (ret != KERN_SUCCESS) {
        [self writeText:@"ERROR: exploit failed"];
        return;
    }
    
    [self writeText:@"exploit succeeded!"];
    
    
    // Write a test file to var
    
    [self writeText:@"writing test file..."];
    
    extern kern_return_t mach_vm_read_overwrite(vm_map_t target_task, mach_vm_address_t address, mach_vm_size_t size, mach_vm_address_t data, mach_vm_size_t *outsize);
    uint32_t magic = 0;
    mach_vm_size_t sz = sizeof(magic);
    ret = mach_vm_read_overwrite(tfp0, 0xfffffff007004000 + kslide, sizeof(magic), (mach_vm_address_t)&magic, &sz);
    LOG("mach_vm_read_overwrite: %x, %s", magic, mach_error_string(ret));
    
    FILE *varF = fopen("/var/mobile/test.txt", "w");
    LOG("var file: %p", varF);
    if (varF == 0) {
        [self writeText:@"ERROR: failed to write test var file"];
        return;
    }
    
    [self writeText:@"wrote test var file!"];
    [self writeText:[NSString stringWithFormat:@"/var/mobile/test.txt (%p)", varF]];
    
    
    // Remount '/' as r/w
    
    int remountOutput = mount_root(tfp0, kslide);
    LOG("remount: %d", remountOutput);
    if (remountOutput != 0) {
        [self writeText:@"ERROR: failed to remount '/' as r/w"];
        return;
    }
    
    [self writeText:@"remounted '/' as r/w"];
    
    
    // Write a test file to root
    
    [self writeText:@"writing test root file..."];
    
    FILE *rootF = fopen("/test.txt", "w");
    LOG("root file: %p", rootF);
    if (rootF == 0) {
        [self writeText:@"ERROR: failed to write root test file"];
        return;
    }
    
    [self writeText:@"wrote test root file!"];
    [self writeText:[NSString stringWithFormat:@"/test.txt (%p)", rootF]];
    
    
    // Done.
    [self writeText:@""];
    [self writeText:@"done."];
}

- (void)writeText:(NSString *)text {
    self.outputView.text = [self.outputView.text stringByAppendingString:[text stringByAppendingString:@"\n"]];
}

@end
