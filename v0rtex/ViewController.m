//
//  ViewController.m
//  v0rtex
//
//  Created by Sticktron on 2017-12-07.
//  Copyright © 2017 Sticktron. All rights reserved.
//

#import "ViewController.h"

#include "v0rtex.h"


@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextView *outputView;
@property (weak, nonatomic) IBOutlet UIButton *sploitButton;
@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.sploitButton.layer.cornerRadius = 6;
    self.outputView.layer.cornerRadius = 6;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)runSploitButton:(UIButton *)sender {
    
    // Run v0rtex
    
    self.outputView.text = [self.outputView.text stringByAppendingString:@"\n > running exploit... \n"];

    task_t tfp0 = MACH_PORT_NULL;
    kptr_t kslide = 0;
    
    kern_return_t v0rtex(task_t *tfp0, kptr_t *kslide);
    kern_return_t ret = v0rtex(&tfp0, &kslide);
    
    if (ret != KERN_SUCCESS) {
        self.outputView.text = [self.outputView.text stringByAppendingString:@"ERROR: exploit failed \n"];
        return;
    }
    
    self.outputView.text = [self.outputView.text stringByAppendingString:@"exploit succeeded! \n"];
    
    
    // Write a test file
    
    self.outputView.text = [self.outputView.text stringByAppendingString:@"writing test file... \n"];
    
    extern kern_return_t mach_vm_read_overwrite(vm_map_t target_task, mach_vm_address_t address, mach_vm_size_t size, mach_vm_address_t data, mach_vm_size_t *outsize);
    uint32_t magic = 0;
    mach_vm_size_t sz = sizeof(magic);
    ret = mach_vm_read_overwrite(tfp0, 0xfffffff007004000 + kslide, sizeof(magic), (mach_vm_address_t)&magic, &sz);
    LOG("mach_vm_read_overwrite: %x, %s", magic, mach_error_string(ret));
    
    FILE *f = fopen("/var/mobile/test.txt", "w");
    LOG("file: %p", f);
    if (f == 0) {
        self.outputView.text = [self.outputView.text stringByAppendingString:@"ERROR: failed to write test file \n"];
        return;
    }
    
    self.outputView.text = [self.outputView.text stringByAppendingString:@"wrote test file! \n"];
    self.outputView.text = [self.outputView.text stringByAppendingString:[NSString stringWithFormat:@"/var/mobile/test.txt (%p) \n", f]];
    
    
    // Next steps ???
    
    
    
    
    // Done.
    self.outputView.text = [self.outputView.text stringByAppendingString:@"\n"];
    self.outputView.text = [self.outputView.text stringByAppendingString:@"done. \n"];
}

@end
