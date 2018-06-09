//
//  symbols.m
//  v0rtex
//
//  Created by Ben on 16/12/2017.
//  Copyright © 2017 Sticktron. All rights reserved.
//

#include <sys/utsname.h>
#include "symbols.h"
#include "common.h"

uint64_t OFFSET_ZONE_MAP;
uint64_t OFFSET_KERNEL_MAP;
uint64_t OFFSET_KERNEL_TASK;
uint64_t OFFSET_REALHOST;
uint64_t OFFSET_BZERO;
uint64_t OFFSET_BCOPY;
uint64_t OFFSET_COPYIN;
uint64_t OFFSET_COPYOUT;
uint64_t OFFSET_CHGPROCCNT;
uint64_t OFFSET_KAUTH_CRED_REF;
uint64_t OFFSET_IPC_PORT_ALLOC_SPECIAL;
uint64_t OFFSET_IPC_KOBJECT_SET;
uint64_t OFFSET_IPC_PORT_MAKE_SEND;
uint64_t OFFSET_IOSURFACEROOTUSERCLIENT_VTAB;
uint64_t OFFSET_OSSERIALIZER_SERIALIZE;
uint64_t OFFSET_ROP_LDR_X0_X0_0x10;
uint64_t OFFSET_ROP_ADD_X0_X0_0x10;
uint64_t OFFSET_ROOT_MOUNT_V_NODE;

#import <sys/utsname.h>

BOOL init_symbols()
{
    NSString *ver = [[NSProcessInfo processInfo] operatingSystemVersionString];
    
    struct utsname u;
    uname(&u);
    
    LOG("Device: %s", u.machine);
    LOG("Device Name: %s", u.version);
    LOG("Device Name: %s", u.nodename);
    LOG("iOS Version: %@", ver);
    
    
    if (strcmp(u.machine, "iPhone9,3") == 0 && [ver isEqual:@"Version 10.3.1 (Build 14E304)"])
    {
        OFFSET_ZONE_MAP                             = 0xfffffff007590478;
        OFFSET_KERNEL_MAP                           = 0xfffffff0075ec050;
        OFFSET_KERNEL_TASK                          = 0xfffffff0075ec048;
        OFFSET_REALHOST                             = 0xfffffff007572ba0;
        OFFSET_BZERO                                = 0xfffffff0070c1f80;
        OFFSET_BCOPY                                = 0xfffffff0070c1dc0;
        OFFSET_COPYIN                               = 0xfffffff0071c6134;
        OFFSET_COPYOUT                              = 0xfffffff0071c6414;
        OFFSET_CHGPROCCNT                           = 0xfffffff007049e4b;
        OFFSET_KAUTH_CRED_REF                       = 0xfffffff0073ada04;
        OFFSET_IPC_PORT_ALLOC_SPECIAL               = 0xfffffff0070df05c;
        OFFSET_IPC_KOBJECT_SET                      = 0xfffffff0070f22b4;
        OFFSET_IPC_PORT_MAKE_SEND                   = 0xfffffff0070deb80;
        OFFSET_IOSURFACEROOTUSERCLIENT_VTAB         = 0xfffffff006e4a238;
        OFFSET_ROP_ADD_X0_X0_0x10                   = 0xfffffff0064ff0a8;
        OFFSET_ROP_LDR_X0_X0_0x10                   = 0xfffffff0074cf02c;
        OFFSET_ROOT_MOUNT_V_NODE                    = 0xfffffff0075ec0b0;
        LOG("loaded offsets for iPhone 7 on 10.3.1");
    }
    
    // iPhone 7 - 10.3.2
    else if (strcmp(u.machine, "iPhone9,1") == 0 && [ver isEqual:@"Version 10.3.2 (Build 14F89)"])
    {
        OFFSET_ZONE_MAP                             = 0xfffffff007590478; /* "zone_init: kmem_suballoc failed" */
        OFFSET_KERNEL_MAP                           = 0xfffffff0075ec050;
        OFFSET_KERNEL_TASK                          = 0xfffffff0075ec048;
        OFFSET_REALHOST                             = 0xfffffff007572ba0; /* host_priv_self */
        OFFSET_BZERO                                = 0xfffffff0070c1f80;
        OFFSET_BCOPY                                = 0xfffffff0070c1dc0;
        OFFSET_COPYIN                               = 0xfffffff0071c6108;
        OFFSET_COPYOUT                              = 0xfffffff0071c63e8;
        OFFSET_CHGPROCCNT                           = 0xfffffff0073d3994;
        OFFSET_KAUTH_CRED_REF                       = 0xfffffff0073add44;
        OFFSET_IPC_PORT_ALLOC_SPECIAL               = 0xfffffff0070deff4; /* convert_task_suspension_token_to_port */
        OFFSET_IPC_KOBJECT_SET                      = 0xfffffff0070f22cc; /* convert_task_suspension_token_to_port */
        OFFSET_IPC_PORT_MAKE_SEND                   = 0xfffffff0070deb18; /* "ipc_host_init" */
        OFFSET_IOSURFACEROOTUSERCLIENT_VTAB         = 0xfffffff006e4a238;
        OFFSET_ROP_ADD_X0_X0_0x10                   = 0xfffffff0063ca398;
        OFFSET_ROP_LDR_X0_X0_0x10                   = 0xfffffff006314a84;
        OFFSET_ROOT_MOUNT_V_NODE                    = 0xfffffff0075ec0b0;
        LOG("loaded offsets for iPhone 7 on 10.3.2");
    }
    // iPhone 6S - 9.3
    else if (strcmp(u.machine, "iPhone8,1") == 0 && [ver isEqual:@"Version 9.3 (Build 13E234)"])
    {
        OFFSET_ZONE_MAP                             = 0xFFFFFF80044B7499; /* "zone_init: kmem_suballoc failed" */
        OFFSET_KERNEL_MAP                           = 0xffffff8004536018;
        OFFSET_KERNEL_TASK                          = 0xffffff8004536010;
        OFFSET_REALHOST                             = 0xffffff8004593e90; /* host_priv_self */
        OFFSET_BZERO                                = 0xffffff80040f2a00;
        OFFSET_BCOPY                                = 0xffffff80040f2840;
        OFFSET_COPYIN                               = 0xffffff80040f2c2c;
        OFFSET_COPYOUT                              = 0xffffff80040f2e08;
        OFFSET_CHGPROCCNT                           = 0xFFFFFF80044A444F;
        OFFSET_KAUTH_CRED_REF                       = 0xffffff800432ec58;
        OFFSET_IPC_PORT_ALLOC_SPECIAL               = 0xffffff800401fe84; /* convert_task_suspension_token_to_port */
        OFFSET_IPC_KOBJECT_SET                      = 0xffffff8004030500; /* convert_task_suspension_token_to_port */
        OFFSET_IPC_PORT_MAKE_SEND                   = 0xffffff800401fb50; /* "ipc_host_init" */
        OFFSET_IOSURFACEROOTUSERCLIENT_VTAB         = 0x00;
        OFFSET_ROP_ADD_X0_X0_0x10                   = 0xffffff8004812d60;
        OFFSET_ROP_LDR_X0_X0_0x10                   = 0xffffff800435f7a0;
        OFFSET_ROOT_MOUNT_V_NODE                    = 0xffffff8004536070;
        LOG("loaded offsets for iPhone 6S on 9.3");
    }
    
    // iPhone 6S 10.2.1
    
    else if (strcmp(u.machine, "iPhone8,1") == 0 && [ver isEqual:@"Version 10.2.1 (Build 15C153)"])
    {
        OFFSET_ZONE_MAP                             = 0xfffffff00709d080; /* "zone_init: kmem_suballoc failed" */
        OFFSET_KERNEL_MAP                           = 0xfffffff007630050;
        OFFSET_KERNEL_TASK                          = 0xfffffff007630048;
        OFFSET_REALHOST                             = 0xfffffff0075c4b98; /* host_priv_self */
        OFFSET_BZERO                                = 0xfffffff007095fc0;
        OFFSET_BCOPY                                = 0xfffffff007095e00;
        OFFSET_COPYIN                               = 0xfffffff0071a4d18;
        OFFSET_COPYOUT                              = 0xfffffff0071a4f48;
        OFFSET_CHGPROCCNT                           = 0xfffffff0073e716c;
        OFFSET_KAUTH_CRED_REF                       = 0xfffffff0073bc46c;
        OFFSET_IPC_PORT_ALLOC_SPECIAL               = 0xfffffff0070b44c8; /* convert_task_suspension_token_to_port */
        OFFSET_IPC_KOBJECT_SET                      = 0xfffffff0070c9600; /* convert_task_suspension_token_to_port */
        OFFSET_IPC_PORT_MAKE_SEND                   = 0xfffffff0070b3f54; /* "ipc_host_init" */
        OFFSET_IOSURFACEROOTUSERCLIENT_VTAB         = 0xfffffff006ee8bc8;
        OFFSET_ROP_ADD_X0_X0_0x10                   = 0xfffffff00656d1e4;
        OFFSET_ROP_LDR_X0_X0_0x10                   = 0xfffffff0062cab3c;
        OFFSET_ROOT_MOUNT_V_NODE                    = 0xfffffff007630088;
        LOG("loaded offsets for iPhone 6S on 10.2.1");
    }
    
    
    else
    {
        LOG("Device not supported.");
        return NO;
    }
    
    return YES;
}
