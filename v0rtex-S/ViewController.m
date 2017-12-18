//
//  ViewController.m
//  v0rtex
//
//  Created by Sticktron on 2017-12-07.
//  Copyright © 2017 Sticktron. All rights reserved.
//

#import "ViewController.h"

#import "v0rtex.h"
#import <sys/utsname.h>


ViewController *controller;


@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextView *outputView;
@property (weak, nonatomic) IBOutlet UIButton *sploitButton;
@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.sploitButton.layer.cornerRadius = 8;
    
    self.outputView.layer.cornerRadius = 6;
    self.outputView.text = @"";
    
    
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

- (void)log:(NSString *)message {
    if (message && self.outputView) {
        self.outputView.text = [self.outputView.text stringByAppendingString:message];
    }
}

- (IBAction)runSploit:(UIButton *)sender {
    
    [self log:@"> exploiting kernel... \n"];
    
    task_t tfp0 = MACH_PORT_NULL;
    kptr_t kslide = 0;
    
    kern_return_t ret = v0rtex(&tfp0, &kslide);
    if (ret != KERN_SUCCESS) {
        [self log:@"ERROR: exploit failed \n\n"];
        return;
    }
    [self log:[NSString stringWithFormat:@"SUCESS: got tfp0 -> %x \n", tfp0]];
    [self log:[NSString stringWithFormat:@"slide = %llx \n", kslide]];
    
    self.sploitButton.enabled = NO;
    
    
    // print kernel magic
    extern kern_return_t mach_vm_read_overwrite(vm_map_t target_task, mach_vm_address_t address, mach_vm_size_t size, mach_vm_address_t data, mach_vm_size_t *outsize);
    uint32_t magic = 0;
    mach_vm_size_t sz = sizeof(magic);
    ret = mach_vm_read_overwrite(tfp0, 0xfffffff007004000 + kslide, sizeof(magic), (mach_vm_address_t)&magic, &sz);
    //LOG("mach_vm_read_overwrite: %x, %s", magic, mach_error_string(ret));
    [self log:[NSString stringWithFormat:@"found kernel magic: %x \n", magic]];
    
    
    // write a test file
    [self log:@"> writing test file... \n"];
    FILE *f = fopen("/var/mobile/test.txt", "w");
    //LOG("file: %p", f);
    if (f == 0) {
        [self log:@"ERROR: failed to write test file \n\n"];
        return;
    }
    [self log:[NSString stringWithFormat:@"wrote /var/mobile/test.txt (%p) \n", f]];
    
    
    // Next steps ???
    
    
    
    
    // Done.
    self.outputView.text = [self.outputView.text stringByAppendingString:@"finished. \n\n"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
