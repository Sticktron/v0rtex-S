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

    // iPhone 7 Global, 9,1, A1660 - 10.3.3
    else if (strcmp(u.machine, "iPhone9,1") == 0 && [ver isEqual:@"Version 10.3.3 (Build 14G60)"])
    {
        OFFSET_ZONE_MAP                             = 0xfffffff007590478;
        OFFSET_KERNEL_MAP                           = 0xfffffff0075ec050;
        OFFSET_KERNEL_TASK                          = 0xfffffff0075ec048;
        OFFSET_REALHOST                             = 0xfffffff007572ba0;
        OFFSET_BZERO                                = 0xfffffff0070c1f80;
        OFFSET_BCOPY                                = 0xfffffff0070c1dc0;
        OFFSET_COPYIN                               = 0xfffffff0071c5db4;
        OFFSET_COPYOUT                              = 0xfffffff0071c6094;
        OFFSET_CHGPROCCNT                           = 0xfffffff0073d38e4;
        OFFSET_KAUTH_CRED_REF                       = 0xfffffff0073adc68;
        OFFSET_IPC_PORT_ALLOC_SPECIAL               = 0xfffffff0070deff4;
        OFFSET_IPC_KOBJECT_SET                      = 0xfffffff0070f22cc;
        OFFSET_IPC_PORT_MAKE_SEND                   = 0xfffffff0070deb18;
        OFFSET_IOSURFACEROOTUSERCLIENT_VTAB         = 0xfffffff006e4a238;
        OFFSET_ROP_ADD_X0_X0_0x10                   = 0xfffffff0063c5398;
        OFFSET_ROP_LDR_X0_X0_0x10                   = 0xfffffff006310a84;
        OFFSET_ROOT_MOUNT_V_NODE                    = 0xfffffff0075ec0b0;
        LOG("loaded offsets for iPhone 7 Global on 10.3.3");
    }    

    
    // iPhone 6S - 10.3.2
    else if (strcmp(u.machine, "iPhone8,1") == 0 && [ver isEqual:@"Version 10.3.2 (Build 14F89)"])
    {
        OFFSET_ZONE_MAP                             = 0xfffffff007548478; /* "zone_init: kmem_suballoc failed" */
        OFFSET_KERNEL_MAP                           = 0xfffffff0075a4050;
        OFFSET_KERNEL_TASK                          = 0xfffffff0075a4048;
        OFFSET_REALHOST                             = 0xfffffff00752aba0; /* host_priv_self */
        OFFSET_BZERO                                = 0xfffffff007081f80;
        OFFSET_BCOPY                                = 0xfffffff007081dc0;
        OFFSET_COPYIN                               = 0xfffffff0071806f4;
        OFFSET_COPYOUT                              = 0xfffffff0071808e8;
        OFFSET_CHGPROCCNT                           = 0xfffffff007049df1;
        OFFSET_KAUTH_CRED_REF                       = 0xfffffff007367cf4;
        OFFSET_IPC_PORT_ALLOC_SPECIAL               = 0xfffffff007099e94; /* convert_task_suspension_token_to_port */
        OFFSET_IPC_KOBJECT_SET                      = 0xfffffff0070ad16c; /* convert_task_suspension_token_to_port */
        OFFSET_IPC_PORT_MAKE_SEND                   = 0xfffffff0070999b8; /* "ipc_host_init" */
        OFFSET_IOSURFACEROOTUSERCLIENT_VTAB         = 0xfffffff006e7c9f8;
        OFFSET_ROP_ADD_X0_X0_0x10                   = 0xfffffff0064b1398;
        OFFSET_ROP_LDR_X0_X0_0x10                   = 0xfffffff0074c31d4;
        OFFSET_ROOT_MOUNT_V_NODE                    = 0xfffffff0075a40b0;
        LOG("loaded offsets for iPhone 6S on 10.3.2");
    }
    
    else
    {
        LOG("Device not supported.");
        return NO;
    }
    
    return YES;
}
