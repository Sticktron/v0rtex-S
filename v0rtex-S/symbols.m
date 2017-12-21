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
#import <sys/sysctl.h>
BOOL init_symbols()
{
    /* old implementation
     NSString *ver = [[NSProcessInfo processInfo] operatingSystemVersionString];
    
    
     struct utsname u;
    uname(&u);
    
    LOG("Device: %s", u.machine);
    LOG("Device Name: %s", u.nodename);
    LOG("Device iOS Version: %@", ver);*/
    
    /* ORIGINAL COMMIT BY @ARX8X */
    /*                           */
    /* https://github.com/talanov/V0rtex-upscale/commit/83f1921e87e45203142a49680df239e85982b521 */
    struct utsname sysinfo;
    uname(&sysinfo);
    const char *kern_version = sysinfo.version;
    
    //read device id
    int d_prop[2] = {CTL_HW, HW_MACHINE};
    char device[20];
    size_t d_prop_len = sizeof(device);
    //sysctl(d_prop, 2, NULL, &d_prop_len, NULL, 0);
    sysctl(d_prop, 2, device, &d_prop_len, NULL, 0);
    
    int version_prop[2] = {CTL_KERN, KERN_OSVERSION};
    char version[20];
    size_t version_prop_len = sizeof(version);
    //sysctl(version_prop, 2, NULL, &version_prop_len, NULL, 0);
    sysctl(version_prop, 2, version, &version_prop_len, NULL, 0);
    
    //exit(1);
    
    //iPad 4 (WiFi)
    if(!strcmp(device, "iPad3,4"))
    {
        //10.3.3
        if(!strcmp(version, "14G60"))
        {
            LOG("10.3.3 - 14G60 offsets not found for %s", device);
            exit(1);
        }
        
        //10.3.2
        if(!strcmp(version, "14F89"))
        {
            LOG("10.3.2 - 14F89 offsets not found for %s", device);
            exit(1);
        }
        
        //10.3.1
        if(!strcmp(version, "14E304"))
        {
            LOG("10.3.1 - 14E304 offsets not found for %s", device);
            exit(1);
        }
        
        //10.3
        if(!strcmp(version, "14E277"))
        {
            LOG("10.3 - 14E277 offsets not found for %s", device);
            exit(1);
        }
        
        
    }
    
    //iPad 4 (GSM)
    else if(!strcmp(device, "iPad3,5"))
    {
        //10.3.3
        if(!strcmp(version, "14G60"))
        {
            LOG("10.3.3 - 14G60 offsets not found for %s", device);
            exit(1);
        }
        
        //10.3.2
        if(!strcmp(version, "14F89"))
        {
            LOG("10.3.2 - 14F89 offsets not found for %s", device);
            exit(1);
        }
        
        //10.3.1
        if(!strcmp(version, "14E304"))
        {
            LOG("10.3.1 - 14E304 offsets not found for %s", device);
            exit(1);
        }
        
        //10.3
        if(!strcmp(version, "14E277"))
        {
            LOG("10.3 - 14E277 offsets not found for %s", device);
            exit(1);
        }
        
        
    }
    
    //iPad 4 (Global)
    else if(!strcmp(device, "iPad3,6"))
    {
        //10.3.3
        if(!strcmp(version, "14G60"))
        {
            LOG("10.3.3 - 14G60 offsets not found for %s", device);
            exit(1);
        }
        
        //10.3.2
        if(!strcmp(version, "14F89"))
        {
            LOG("10.3.2 - 14F89 offsets not found for %s", device);
            exit(1);
        }
        
        //10.3.1
        if(!strcmp(version, "14E304"))
        {
            LOG("10.3.1 - 14E304 offsets not found for %s", device);
            exit(1);
        }
        
        //10.3
        if(!strcmp(version, "14E277"))
        {
            LOG("10.3 - 14E277 offsets not found for %s", device);
            exit(1);
        }
        
        
    }
    
    //iPad Air (WiFi)
    else if(!strcmp(device, "iPad4,1"))
    {
        //10.3.3
        if(!strcmp(version, "14G60"))
        {
            LOG("10.3.3 - 14G60 offsets not found for %s", device);
            exit(1);
        }
        
        //10.3.2
        if(!strcmp(version, "14F89"))
        {
            LOG("10.3.2 - 14F89 offsets not found for %s", device);
            exit(1);
        }
        
        //10.3.1
        if(!strcmp(version, "14E304"))
        {
            LOG("10.3.1 - 14E304 offsets not found for %s", device);
            exit(1);
        }
        
        //10.3
        if(!strcmp(version, "14E277"))
        {
            LOG("10.3 - 14E277 offsets not found for %s", device);
            exit(1);
        }
        
        
    }
    
    //iPad Air (Cellular)
    else if(!strcmp(device, "iPad4,2"))
    {
        //10.3.3
        if(!strcmp(version, "14G60"))
        {
            LOG("10.3.3 - 14G60 offsets not found for %s", device);
            exit(1);
        }
        
        //10.3.2
        if(!strcmp(version, "14F89"))
        {
            LOG("10.3.2 - 14F89 offsets not found for %s", device);
            exit(1);
        }
        
        //10.3.1
        if(!strcmp(version, "14E304"))
        {
            LOG("10.3.1 - 14E304 offsets not found for %s", device);
            exit(1);
        }
        
        //10.3
        if(!strcmp(version, "14E277"))
        {
            LOG("10.3 - 14E277 offsets not found for %s", device);
            exit(1);
        }
        
        
    }
    
    //iPad Air (China)
    else if(!strcmp(device, "iPad4,3"))
    {
        //10.3.3
        if(!strcmp(version, "14G60"))
        {
            LOG("10.3.3 - 14G60 offsets not found for %s", device);
            exit(1);
        }
        
        //10.3.2
        if(!strcmp(version, "14F89"))
        {
            LOG("10.3.2 - 14F89 offsets not found for %s", device);
            exit(1);
        }
        
        //10.3.1
        if(!strcmp(version, "14E304"))
        {
            LOG("10.3.1 - 14E304 offsets not found for %s", device);
            exit(1);
        }
        
        //10.3
        if(!strcmp(version, "14E277"))
        {
            LOG("10.3 - 14E277 offsets not found for %s", device);
            exit(1);
        }
        
        
    }
    
    //iPad Mini 2 (WiFi)
    else if(!strcmp(device, "iPad4,4"))
    {
        //10.3.3
        if(!strcmp(version, "14G60"))
        {
            LOG("10.3.3 - 14G60 offsets not found for %s", device);
            exit(1);
        }
        
        //10.3.2
        if(!strcmp(version, "14F89"))
        {
            LOG("10.3.2 - 14F89 offsets not found for %s", device);
            exit(1);
        }
        
        //10.3.1
        if(!strcmp(version, "14E304"))
        {
            OFFSET_COPYIN                               = 0xfffffff007181218;
            OFFSET_KERNEL_TASK                          = 0xfffffff0075a8048;
            OFFSET_REALHOST                             = 0xfffffff00752eba0;
            OFFSET_BZERO                                = 0xfffffff007081f80;
            OFFSET_IPC_KOBJECT_SET                      = 0xfffffff0070ad1d4;
            OFFSET_ROP_ADD_X0_X0_0x10                   = 0xfffffff0064fd174;
            OFFSET_COPYOUT                              = 0xfffffff00718140c;
            OFFSET_ZONE_MAP                             = 0xfffffff00754c478;
            OFFSET_IPC_PORT_ALLOC_SPECIAL               = 0xfffffff007099f7c;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB         = 0xfffffff006f2e338;
            OFFSET_KERNEL_MAP                           = 0xfffffff0075a8050;
            OFFSET_BCOPY                                = 0xfffffff007081dc0;
            OFFSET_IPC_PORT_MAKE_SEND                   = 0xfffffff007099aa0;
        }
        
        //10.3
        if(!strcmp(version, "14E277"))
        {
            LOG("10.3 - 14E277 offsets not found for %s", device);
            exit(1);
        }
        
        
    }
    
    //iPad Mini 2 (Cellular)
    else if(!strcmp(device, "iPad4,5"))
    {
        //10.3.3
        if(!strcmp(version, "14G60"))
        {
            OFFSET_ZONE_MAP                             = 0xfffffff00754c478;
            OFFSET_KERNEL_MAP                           = 0xfffffff0075a8050;
            OFFSET_KERNEL_TASK                          = 0xfffffff0075a8048;
            OFFSET_REALHOST                             = 0xfffffff00752eba0;
            OFFSET_BZERO                                = 0xfffffff007081f80;
            OFFSET_BCOPY                                = 0xfffffff007081dc0;
            OFFSET_COPYIN                               = 0xfffffff007180e98;
            OFFSET_COPYOUT                              = 0xfffffff00718108c;
            OFFSET_IPC_PORT_ALLOC_SPECIAL               = 0xfffffff007099f14;
            OFFSET_IPC_KOBJECT_SET                      = 0xfffffff0070ad1ec;
            OFFSET_IPC_PORT_MAKE_SEND                   = 0xfffffff007099a38;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB         = 0xfffffff006f2e338;
            OFFSET_ROP_ADD_X0_X0_0x10                   = 0xfffffff0064fe174;
        }
        
        //10.3.2
        if(!strcmp(version, "14F89"))
        {
            LOG("10.3.2 - 14F89 offsets not found for %s", device);
            exit(1);
        }
        
        //10.3.1
        if(!strcmp(version, "14E304"))
        {
            LOG("10.3.1 - 14E304 offsets not found for %s", device);
            exit(1);
        }
        
        //10.3
        if(!strcmp(version, "14E277"))
        {
            LOG("10.3 - 14E277 offsets not found for %s", device);
            exit(1);
        }
        
        
    }
    
    //iPad Mini 2 (China)
    else if(!strcmp(device, "iPad4,6"))
    {
        //10.3.3
        if(!strcmp(version, "14G60"))
        {
            LOG("10.3.3 - 14G60 offsets not found for %s", device);
            exit(1);
        }
        
        //10.3.2
        if(!strcmp(version, "14F89"))
        {
            LOG("10.3.2 - 14F89 offsets not found for %s", device);
            exit(1);
        }
        
        //10.3.1
        if(!strcmp(version, "14E304"))
        {
            LOG("10.3.1 - 14E304 offsets not found for %s", device);
            exit(1);
        }
        
        //10.3
        if(!strcmp(version, "14E277"))
        {
            LOG("10.3 - 14E277 offsets not found for %s", device);
            exit(1);
        }
        
        
    }
    
    //iPad Mini 3 (WiFi)
    else if(!strcmp(device, "iPad4,7"))
    {
        //10.3.3
        if(!strcmp(version, "14G60"))
        {
            LOG("10.3.3 - 14G60 offsets not found for %s", device);
            exit(1);
        }
        
        //10.3.2
        if(!strcmp(version, "14F89"))
        {
            LOG("10.3.2 - 14F89 offsets not found for %s", device);
            exit(1);
        }
        
        //10.3.1
        if(!strcmp(version, "14E304"))
        {
            LOG("10.3.1 - 14E304 offsets not found for %s", device);
            exit(1);
        }
        
        //10.3
        if(!strcmp(version, "14E277"))
        {
            LOG("10.3 - 14E277 offsets not found for %s", device);
            exit(1);
        }
        
        
    }
    
    //iPad Mini 3 (Cellular)
    else if(!strcmp(device, "iPad4,8"))
    {
        //10.3.3
        if(!strcmp(version, "14G60"))
        {
            LOG("10.3.3 - 14G60 offsets not found for %s", device);
            exit(1);
        }
        
        //10.3.2
        if(!strcmp(version, "14F89"))
        {
            LOG("10.3.2 - 14F89 offsets not found for %s", device);
            exit(1);
        }
        
        //10.3.1
        if(!strcmp(version, "14E304"))
        {
            LOG("10.3.1 - 14E304 offsets not found for %s", device);
            exit(1);
        }
        
        //10.3
        if(!strcmp(version, "14E277"))
        {
            LOG("10.3 - 14E277 offsets not found for %s", device);
            exit(1);
        }
        
        
    }
    
    //iPad Mini 3 (China)
    else if(!strcmp(device, "iPad4,9"))
    {
        //10.3.3
        if(!strcmp(version, "14G60"))
        {
            LOG("10.3.3 - 14G60 offsets not found for %s", device);
            exit(1);
        }
        
        //10.3.2
        if(!strcmp(version, "14F89"))
        {
            LOG("10.3.2 - 14F89 offsets not found for %s", device);
            exit(1);
        }
        
        //10.3.1
        if(!strcmp(version, "14E304"))
        {
            LOG("10.3.1 - 14E304 offsets not found for %s", device);
            exit(1);
        }
        
        //10.3
        if(!strcmp(version, "14E277"))
        {
            LOG("10.3 - 14E277 offsets not found for %s", device);
            exit(1);
        }
        
        
    }
    
    //iPad Mini 4 (WiFi)
    else if(!strcmp(device, "iPad5,1"))
    {
        //10.3.3
        if(!strcmp(version, "14G60"))
        {
            LOG("10.3.3 - 14G60 offsets not found for %s", device);
            exit(1);
        }
        
        //10.3.2
        if(!strcmp(version, "14F89"))
        {
            LOG("10.3.2 - 14F89 offsets not found for %s", device);
            exit(1);
        }
        
        //10.3.1
        if(!strcmp(version, "14E304"))
        {
            LOG("10.3.1 - 14E304 offsets not found for %s", device);
            exit(1);
        }
        
        //10.3
        if(!strcmp(version, "14E277"))
        {
            LOG("10.3 - 14E277 offsets not found for %s", device);
            exit(1);
        }
        
        
    }
    
    //iPad Mini 4 (Cellular)
    else if(!strcmp(device, "iPad5,2"))
    {
        //10.3.3
        if(!strcmp(version, "14G60"))
        {
            LOG("10.3.3 - 14G60 offsets not found for %s", device);
            exit(1);
        }
        
        //10.3.2
        if(!strcmp(version, "14F91"))
        {
            LOG("10.3.2 - 14F91 offsets not found for %s", device);
            exit(1);
        }
        
        //10.3.1
        if(!strcmp(version, "14E304"))
        {
            LOG("10.3.1 - 14E304 offsets not found for %s", device);
            exit(1);
        }
        
        //10.3
        if(!strcmp(version, "14E277"))
        {
            LOG("10.3 - 14E277 offsets not found for %s", device);
            exit(1);
        }
        
        
    }
    
    //iPad Air 2 (WiFi)
    else if(!strcmp(device, "iPad5,3"))
    {
        //10.3.3
        if(!strcmp(version, "14G60"))
        {
            LOG("10.3.3 - 14G60 offsets not found for %s", device);
            exit(1);
        }
        
        //10.3.2
        if(!strcmp(version, "14F89"))
        {
            LOG("10.3.2 - 14F89 offsets not found for %s", device);
            exit(1);
        }
        
        //10.3.1
        if(!strcmp(version, "14E304"))
        {
            LOG("10.3.1 - 14E304 offsets not found for %s", device);
            exit(1);
        }
        
        //10.3
        if(!strcmp(version, "14E277"))
        {
            LOG("10.3 - 14E277 offsets not found for %s", device);
            exit(1);
        }
        
        
    }
    
    //iPad Air 2 (Cellular)
    else if(!strcmp(device, "iPad5,4"))
    {
        //10.3.3
        if(!strcmp(version, "14G60"))
        {
            LOG("10.3.3 - 14G60 offsets not found for %s", device);
            exit(1);
        }
        
        //10.3.2
        if(!strcmp(version, "14F89"))
        {
            LOG("10.3.2 - 14F89 offsets not found for %s", device);
            exit(1);
        }
        
        //10.3.1
        if(!strcmp(version, "14E304"))
        {
            LOG("10.3.1 - 14E304 offsets not found for %s", device);
            exit(1);
        }
        
        //10.3
        if(!strcmp(version, "14E277"))
        {
            LOG("10.3 - 14E277 offsets not found for %s", device);
            exit(1);
        }
        
        
    }
    
    //iPad 5 (WiFi)
    else if(!strcmp(device, "iPad6,11"))
    {
        //10.3.3
        if(!strcmp(version, "14G60"))
        {
            LOG("10.3.3 - 14G60 offsets not found for %s", device);
            exit(1);
        }
        
        //10.3.2
        if(!strcmp(version, "14F90"))
        {
            LOG("10.3.2 - 14F90 offsets not found for %s", device);
            exit(1);
        }
        
        //10.3.1
        if(!strcmp(version, "14E304"))
        {
            LOG("10.3.1 - 14E304 offsets not found for %s", device);
            exit(1);
        }
        
        //10.3
        if(!strcmp(version, "14E277"))
        {
            LOG("10.3 - 14E277 offsets not found for %s", device);
            exit(1);
        }
        
        
    }
    
    //iPad 5 (Cellular)
    else if(!strcmp(device, "iPad6,12"))
    {
        //10.3.3
        if(!strcmp(version, "14G60"))
        {
            LOG("10.3.3 - 14G60 offsets not found for %s", device);
            exit(1);
        }
        
        //10.3.2
        if(!strcmp(version, "14F90"))
        {
            LOG("10.3.2 - 14F90 offsets not found for %s", device);
            exit(1);
        }
        
        //10.3.1
        if(!strcmp(version, "14E304"))
        {
            LOG("10.3.1 - 14E304 offsets not found for %s", device);
            exit(1);
        }
        
        //10.3
        if(!strcmp(version, "14E277"))
        {
            LOG("10.3 - 14E277 offsets not found for %s", device);
            exit(1);
        }
        
        
    }
    
    //iPad Pro 9.7-inch (WiFi)
    else if(!strcmp(device, "iPad6,3"))
    {
        //10.3.3
        if(!strcmp(version, "14G60"))
        {
            LOG("10.3.3 - 14G60 offsets not found for %s", device);
            exit(1);
        }
        
        //10.3.2
        if(!strcmp(version, "14F89"))
        {
            LOG("10.3.2 - 14F89 offsets not found for %s", device);
            exit(1);
        }
        
        //10.3.1
        if(!strcmp(version, "14E304"))
        {
            LOG("10.3.1 - 14E304 offsets not found for %s", device);
            exit(1);
        }
        
        //10.3
        if(!strcmp(version, "14E277"))
        {
            LOG("10.3 - 14E277 offsets not found for %s", device);
            exit(1);
        }
        
        
    }
    
    //iPad Pro 9.7-inch (Cellular)
    else if(!strcmp(device, "iPad6,4"))
    {
        //10.3.3
        if(!strcmp(version, "14G60"))
        {
            LOG("10.3.3 - 14G60 offsets not found for %s", device);
            exit(1);
        }
        
        //10.3.2
        if(!strcmp(version, "14F89"))
        {
            LOG("10.3.2 - 14F89 offsets not found for %s", device);
            exit(1);
        }
        
        //10.3.1
        if(!strcmp(version, "14E304"))
        {
            LOG("10.3.1 - 14E304 offsets not found for %s", device);
            exit(1);
        }
        
        //10.3
        if(!strcmp(version, "14E277"))
        {
            LOG("10.3 - 14E277 offsets not found for %s", device);
            exit(1);
        }
        
        
    }
    
    //iPad Pro 12.9-inch (WiFi)
    else if(!strcmp(device, "iPad6,7"))
    {
        //10.3.3
        if(!strcmp(version, "14G60"))
        {
            LOG("10.3.3 - 14G60 offsets not found for %s", device);
            exit(1);
        }
        
        //10.3.2
        if(!strcmp(version, "14F89"))
        {
            LOG("10.3.2 - 14F89 offsets not found for %s", device);
            exit(1);
        }
        
        //10.3.1
        if(!strcmp(version, "14E304"))
        {
            LOG("10.3.1 - 14E304 offsets not found for %s", device);
            exit(1);
        }
        
        //10.3
        if(!strcmp(version, "14E277"))
        {
            LOG("10.3 - 14E277 offsets not found for %s", device);
            exit(1);
        }
        
        
    }
    
    //iPad Pro 12.9-inch (Cellular)
    else if(!strcmp(device, "iPad6,8"))
    {
        //10.3.3
        if(!strcmp(version, "14G60"))
        {
            LOG("10.3.3 - 14G60 offsets not found for %s", device);
            exit(1);
        }
        
        //10.3.2
        if(!strcmp(version, "14F89"))
        {
            LOG("10.3.2 - 14F89 offsets not found for %s", device);
            exit(1);
        }
        
        //10.3.1
        if(!strcmp(version, "14E304"))
        {
            LOG("10.3.1 - 14E304 offsets not found for %s", device);
            exit(1);
        }
        
        //10.3
        if(!strcmp(version, "14E277"))
        {
            LOG("10.3 - 14E277 offsets not found for %s", device);
            exit(1);
        }
        
        
    }
    
    //iPad Pro 2 (12.9-inch, WiFi)
    else if(!strcmp(device, "iPad7,1"))
    {
        //10.3.3
        if(!strcmp(version, "14G60"))
        {
            LOG("10.3.3 - 14G60 offsets not found for %s", device);
            exit(1);
        }
        
        //10.3.2
        if(!strcmp(version, "14F8089"))
        {
            LOG("10.3.2 - 14F8089 offsets not found for %s", device);
            exit(1);
        }
        
        
    }
    
    //iPad Pro 2 (12.9-inch, Cellular)
    else if(!strcmp(device, "iPad7,2"))
    {
        //10.3.3
        if(!strcmp(version, "14G60"))
        {
            LOG("10.3.3 - 14G60 offsets not found for %s", device);
            exit(1);
        }
        
        //10.3.2
        if(!strcmp(version, "14F8089"))
        {
            LOG("10.3.2 - 14F8089 offsets not found for %s", device);
            exit(1);
        }
        
        
    }
    
    //iPad Pro (10.5-inch, WiFi)
    else if(!strcmp(device, "iPad7,3"))
    {
        //10.3.3
        if(!strcmp(version, "14G60"))
        {
            LOG("10.3.3 - 14G60 offsets not found for %s", device);
            exit(1);
        }
        
        //10.3.2
        if(!strcmp(version, "14F8089"))
        {
            LOG("10.3.2 - 14F8089 offsets not found for %s", device);
            exit(1);
        }
        
        
    }
    
    //iPad Pro (10.5-inch, Cellular)
    else if(!strcmp(device, "iPad7,4"))
    {
        //10.3.3
        if(!strcmp(version, "14G60"))
        {
            LOG("10.3.3 - 14G60 offsets not found for %s", device);
            exit(1);
        }
        
        //10.3.2
        if(!strcmp(version, "14F8089"))
        {
            LOG("10.3.2 - 14F8089 offsets not found for %s", device);
            exit(1);
        }
        
        
    }
    
    //iPhone 5 (GSM)
    else if(!strcmp(device, "iPhone5,1"))
    {
        //10.3.3
        if(!strcmp(version, "14G60"))
        {
            LOG("10.3.3 - 14G60 offsets not found for %s", device);
            exit(1);
        }
        
        //10.3.2
        if(!strcmp(version, "14F89"))
        {
            LOG("10.3.2 - 14F89 offsets not found for %s", device);
            exit(1);
        }
        
        //10.3.1
        if(!strcmp(version, "14E304"))
        {
            LOG("10.3.1 - 14E304 offsets not found for %s", device);
            exit(1);
        }
        
        //10.3
        if(!strcmp(version, "14E277"))
        {
            LOG("10.3 - 14E277 offsets not found for %s", device);
            exit(1);
        }
        
        
    }
    
    //iPhone 5 (Global)
    else if(!strcmp(device, "iPhone5,2"))
    {
        //10.3.3
        if(!strcmp(version, "14G60"))
        {
            LOG("10.3.3 - 14G60 offsets not found for %s", device);
            exit(1);
        }
        
        //10.3.2
        if(!strcmp(version, "14F89"))
        {
            LOG("10.3.2 - 14F89 offsets not found for %s", device);
            exit(1);
        }
        
        //10.3.1
        if(!strcmp(version, "14E304"))
        {
            LOG("10.3.1 - 14E304 offsets not found for %s", device);
            exit(1);
        }
        
        //10.3
        if(!strcmp(version, "14E277"))
        {
            LOG("10.3 - 14E277 offsets not found for %s", device);
            exit(1);
        }
        
        
    }
    
    //iPhone 5c (GSM)
    else if(!strcmp(device, "iPhone5,3"))
    {
        //10.3.3
        if(!strcmp(version, "14G60"))
        {
            LOG("10.3.3 - 14G60 offsets not found for %s", device);
            exit(1);
        }
        
        //10.3.2
        if(!strcmp(version, "14F89"))
        {
            LOG("10.3.2 - 14F89 offsets not found for %s", device);
            exit(1);
        }
        
        //10.3.1
        if(!strcmp(version, "14E304"))
        {
            LOG("10.3.1 - 14E304 offsets not found for %s", device);
            exit(1);
        }
        
        //10.3
        if(!strcmp(version, "14E277"))
        {
            LOG("10.3 - 14E277 offsets not found for %s", device);
            exit(1);
        }
        
        
    }
    
    //iPhone 5c (Global)
    else if(!strcmp(device, "iPhone5,4"))
    {
        //10.3.3
        if(!strcmp(version, "14G60"))
        {
            LOG("10.3.3 - 14G60 offsets not found for %s", device);
            exit(1);
        }
        
        //10.3.2
        if(!strcmp(version, "14F89"))
        {
            LOG("10.3.2 - 14F89 offsets not found for %s", device);
            exit(1);
        }
        
        //10.3.1
        if(!strcmp(version, "14E304"))
        {
            LOG("10.3.1 - 14E304 offsets not found for %s", device);
            exit(1);
        }
        
        //10.3
        if(!strcmp(version, "14E277"))
        {
            LOG("10.3 - 14E277 offsets not found for %s", device);
            exit(1);
        }
        
        
    }
    
    
    //iPhone 5s
    else if(!strcmp(device, "iPhone6,2") || !strcmp(device, "iPhone6,1"))
    {
        //10.3.3
        if(!strcmp(version, "14G60"))
        {
            OFFSET_ZONE_MAP                             = 0xfffffff00754c478;
            OFFSET_KERNEL_MAP                           = 0xfffffff0075a8050;
            OFFSET_KERNEL_TASK                          = 0xfffffff0075a8048;
            OFFSET_REALHOST                             = 0xfffffff00752eba0;
            OFFSET_BZERO                                = 0xfffffff007081f80;
            OFFSET_BCOPY                                = 0xfffffff007081dc0;
            OFFSET_COPYIN                               = 0xfffffff007180e98;
            OFFSET_COPYOUT                              = 0xfffffff00718108c;
            OFFSET_IPC_PORT_ALLOC_SPECIAL               = 0xfffffff007099f14;
            OFFSET_IPC_KOBJECT_SET                      = 0xfffffff0070ad1ec;
            OFFSET_IPC_PORT_MAKE_SEND                   = 0xfffffff007099a38;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB         = 0xfffffff006f25538;
            OFFSET_ROP_ADD_X0_X0_0x10                   = 0xfffffff006522174;
        }
        
        //10.3.2
        if(!strcmp(version, "14F89"))
        {
            OFFSET_ZONE_MAP                             = 0xfffffff00754c478;
            OFFSET_KERNEL_MAP                           = 0xfffffff0075a8050;
            OFFSET_KERNEL_TASK                          = 0xfffffff0075a8048;
            OFFSET_REALHOST                             = 0xfffffff00752eba0;
            OFFSET_BZERO                                = 0xfffffff007081f80;
            OFFSET_BCOPY                                = 0xfffffff007081dc0;
            OFFSET_COPYIN                               = 0xfffffff0071811ec;
            OFFSET_COPYOUT                              = 0xfffffff0071813e0;
            OFFSET_IPC_PORT_ALLOC_SPECIAL               = 0xfffffff007099f14;
            OFFSET_IPC_KOBJECT_SET                      = 0xfffffff0070ad1ec;
            OFFSET_IPC_PORT_MAKE_SEND                   = 0xfffffff007099a38;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB         = 0xfffffff006f25538;
            OFFSET_ROP_ADD_X0_X0_0x10                   = 0xfffffff006526174;
        }
        
        //10.3.1
        if(!strcmp(version, "14E304"))
        {
            OFFSET_ZONE_MAP                             = 0xfffffff00754c478;
            OFFSET_KERNEL_MAP                           = 0xfffffff0075a8050;
            OFFSET_KERNEL_TASK                          = 0xfffffff0075a8048;
            OFFSET_REALHOST                             = 0xfffffff00752eba0;
            OFFSET_BZERO                                = 0xfffffff007081f80;
            OFFSET_BCOPY                                = 0xfffffff007081dc0;
            OFFSET_COPYIN                               = 0xfffffff007181218;
            OFFSET_COPYOUT                              = 0xfffffff00718140c;
            OFFSET_IPC_PORT_ALLOC_SPECIAL               = 0xfffffff007099f7c;
            OFFSET_IPC_KOBJECT_SET                      = 0xfffffff0070ad1d4;
            OFFSET_IPC_PORT_MAKE_SEND                   = 0xfffffff007099aa0;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB         = 0xfffffff006f25538;
            OFFSET_ROP_ADD_X0_X0_0x10                   = 0xfffffff006525174;
        }
        
        //10.3
        if(!strcmp(version, "14E277"))
        {
            LOG("10.3 - 14E277 offsets not found for %s", device);
            exit(1);
        }
        
        
    }
    
    //iPhone 6+
    else if(!strcmp(device, "iPhone7,1"))
    {
        //10.3.3
        if(!strcmp(version, "14G60"))
        {
            LOG("10.3.3 - 14G60 offsets not found for %s", device);
            exit(1);
        }
        
        //10.3.2
        if(!strcmp(version, "14F89"))
        {
            LOG("10.3.2 - 14F89 offsets not found for %s", device);
            exit(1);
        }
        
        //10.3.1
        if(!strcmp(version, "14E304"))
        {
            LOG("10.3.1 - 14E304 offsets not found for %s", device);
            exit(1);
        }
        
        //10.3
        if(!strcmp(version, "14E277"))
        {
            LOG("10.3 - 14E277 offsets not found for %s", device);
            exit(1);
        }
        
        
    }
    
    //iPhone 6
    else if(!strcmp(device, "iPhone7,2"))
    {
        //10.3.3
        if(!strcmp(version, "14G60"))
        {
            OFFSET_ZONE_MAP                             = 0xfffffff007558478;
            OFFSET_KERNEL_MAP                           = 0xfffffff0075b4050;
            OFFSET_KERNEL_TASK                          = 0xfffffff0075b4048;
            OFFSET_REALHOST                             = 0xfffffff00753aba0;
            OFFSET_BZERO                                = 0xfffffff00708df80;
            OFFSET_BCOPY                                = 0xfffffff00708ddc0;
            OFFSET_COPYIN                               = 0xfffffff00718d028;
            OFFSET_COPYOUT                              = 0xfffffff00718d21c;
            OFFSET_IPC_PORT_ALLOC_SPECIAL               = 0xfffffff0070a60b4;
            OFFSET_IPC_KOBJECT_SET                      = 0xfffffff0070b938c;
            OFFSET_IPC_PORT_MAKE_SEND                   = 0xfffffff0070a5bd8;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB         = 0xfffffff006135000 + 0x1030;
            OFFSET_ROP_ADD_X0_X0_0x10                   = 0xfffffff0064b2174;
        }
        
        //10.3.2
        if(!strcmp(version, "14F89"))
        {
            OFFSET_ZONE_MAP                             = 0xfffffff007558478;
            OFFSET_KERNEL_MAP                           = 0xfffffff0075b4050;
            OFFSET_KERNEL_TASK                          = 0xfffffff0075b4048;
            OFFSET_REALHOST                             = 0xfffffff00753aba0;
            OFFSET_BZERO                                = 0xfffffff00708df80;
            OFFSET_BCOPY                                = 0xfffffff00708ddc0;
            OFFSET_COPYIN                               = 0xfffffff00718d37c;
            OFFSET_COPYOUT                              = 0xfffffff00718d570;
            OFFSET_IPC_PORT_ALLOC_SPECIAL               = 0xfffffff0070a60b4;
            OFFSET_IPC_KOBJECT_SET                      = 0xfffffff0070b938c;
            OFFSET_IPC_PORT_MAKE_SEND                   = 0xfffffff0070a5bd8;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB         = 0xfffffff006eee1b8;
            //OFFSET_ROP_ADD_X0_X0_0x10                   = 0xfffffff0064b2174;
            OFFSET_ROP_ADD_X0_X0_0x10                   = 0xfffffff006642c90;
        }
        
        //10.3.1
        if(!strcmp(version, "14E304"))
        {
            OFFSET_ZONE_MAP                             = 0xfffffff007558478;
            OFFSET_KERNEL_MAP                           = 0xfffffff0075b4050;
            OFFSET_KERNEL_TASK                          = 0xfffffff0075b4048;
            OFFSET_REALHOST                             = 0xfffffff00753aba0;
            OFFSET_BZERO                                = 0xfffffff00708df80;
            OFFSET_BCOPY                                = 0xfffffff00708ddc0;
            OFFSET_COPYIN                               = 0xfffffff00718d3a8;
            OFFSET_COPYOUT                              = 0xfffffff00718d59c;
            OFFSET_IPC_PORT_ALLOC_SPECIAL               = 0xfffffff0070a611c;
            OFFSET_IPC_KOBJECT_SET                      = 0xfffffff0070b9374;
            OFFSET_IPC_PORT_MAKE_SEND                   = 0xfffffff0070a5c40;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB         = 0xfffffff006eed2b8;
            OFFSET_ROP_ADD_X0_X0_0x10                   = 0xfffffff0064b5174;
        }
        
        //10.3
        if(!strcmp(version, "14E277"))
        {
            LOG("10.3 - 14E277 offsets not found for %s", device);
            exit(1);
        }
        
        
    }
    
    //iPhone 6s
    else if(!strcmp(device, "iPhone8,1"))
    {
        //10.3.3
        if(!strcmp(version, "14G60"))
        {
            LOG("6S, 10.3.3");
            OFFSET_ZONE_MAP                             = 0xfffffff007548478;
            OFFSET_KERNEL_MAP                           = 0xfffffff0075a4050;
            OFFSET_KERNEL_TASK                          = 0xfffffff0075a4048;
            OFFSET_REALHOST                             = 0xfffffff00752aba0;
            OFFSET_BZERO                                = 0xfffffff007081f80;
            OFFSET_BCOPY                                = 0xfffffff007081dc0;
            OFFSET_COPYIN                               = 0xfffffff0071803a0;
            OFFSET_COPYOUT                              = 0xfffffff007180594;
            OFFSET_IPC_PORT_ALLOC_SPECIAL               = 0xfffffff007099e94;
            OFFSET_IPC_KOBJECT_SET                      = 0xfffffff0070ad16c;
            OFFSET_IPC_PORT_MAKE_SEND                   = 0xfffffff0070999b8;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB         = 0xfffffff006e7c9f8;
            OFFSET_ROP_ADD_X0_X0_0x10                   = 0xfffffff006462174;
        }
        
        //10.3.2
        if(!strcmp(version, "14F89"))
        {
            OFFSET_ZONE_MAP                             = 0xfffffff007548478;
            OFFSET_KERNEL_MAP                           = 0xfffffff0075a4050;
            OFFSET_KERNEL_TASK                          = 0xfffffff0075a4048;
            OFFSET_REALHOST                             = 0xfffffff00752aba0;
            OFFSET_BZERO                                = 0xfffffff007081f80;
            OFFSET_BCOPY                                = 0xfffffff007081dc0;
            OFFSET_COPYIN                               = 0xfffffff0071806f4;
            OFFSET_COPYOUT                              = 0xfffffff0071808e8;
            OFFSET_IPC_PORT_ALLOC_SPECIAL               = 0xfffffff007099e94;
            OFFSET_IPC_KOBJECT_SET                      = 0xfffffff0070ad16c;
            OFFSET_IPC_PORT_MAKE_SEND                   = 0xfffffff0070999b8;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB         = 0xfffffff006e7c9f8;
            OFFSET_ROP_ADD_X0_X0_0x10                   = 0xfffffff0064b1398;
        }
        
        //10.3.1
        if(!strcmp(version, "14E304"))
        {
            LOG("10.3.1 - 14E304 offsets not found for %s", device);
            exit(1);
        }
        
        //10.3
        if(!strcmp(version, "14E277"))
        {
            LOG("10.3 - 14E277 offsets not found for %s", device);
            exit(1);
        }
        
        
    }
    
    //iPhone 6s+
    else if(!strcmp(device, "iPhone8,2"))
    {
        //10.3.3
        if(!strcmp(version, "14G60"))
        {
            LOG("10.3.3 - 14G60 offsets not found for %s", device);
            exit(1);
        }
        
        //10.3.2
        if(!strcmp(version, "14F89"))
        {
            LOG("10.3.2 - 14F89 offsets not found for %s", device);
            exit(1);
        }
        
        //10.3.1
        if(!strcmp(version, "14E304"))
        {
            LOG("10.3.1 - 14E304 offsets not found for %s", device);
            exit(1);
        }
        
        //10.3
        if(!strcmp(version, "14E277"))
        {
            LOG("10.3 - 14E277 offsets not found for %s", device);
            exit(1);
        }
        
        
    }
    
    //iPhone SE
    else if(!strcmp(device, "iPhone8,4"))
    {
        //10.3.3
        if(!strcmp(version, "14G60"))
        {
            LOG("10.3.3 - 14G60 offsets not found for %s", device);
            exit(1);
        }
        
        //10.3.2
        if(!strcmp(version, "14F89"))
        {
            OFFSET_ZONE_MAP                             = 0xfffffff007548478;
            OFFSET_KERNEL_MAP                           = 0xfffffff007081dc0;
            OFFSET_KERNEL_TASK                          = 0xfffffff0071806f4;
            OFFSET_REALHOST                             = 0xfffffff00752aba0;
            OFFSET_BZERO                                = 0xfffffff007081f80;
            OFFSET_BCOPY                                = 0xfffffff0071808e8;
            OFFSET_COPYIN                               = 0xfffffff0075a4050;
            OFFSET_COPYOUT                              = 0xfffffff0075a4048;
            OFFSET_IPC_PORT_ALLOC_SPECIAL               = 0xfffffff007099e94;
            OFFSET_IPC_KOBJECT_SET                      = 0xfffffff0070ad16c;
            OFFSET_IPC_PORT_MAKE_SEND                   = 0xfffffff0070999b8;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB         = 0xfffffff006e849f8;
            OFFSET_ROP_ADD_X0_X0_0x10                   = 0xfffffff006482174;
        }
        
        //10.3.1
        if(!strcmp(version, "14E304"))
        {
            LOG("10.3.1 - 14E304 offsets not found for %s", device);
            exit(1);
        }
        
        //10.3
        if(!strcmp(version, "14E277"))
        {
            LOG("10.3 - 14E277 offsets not found for %s", device);
            exit(1);
        }
        
        
    }
    
    //iPhone 7
    else if(!strcmp(device, "iPhone9,3") || !strcmp(device, "iPhone9,1"))
    {
        //10.3.3
        if(!strcmp(version, "14G60"))
        {
            OFFSET_ZONE_MAP                             = 0xfffffff007590478;
            OFFSET_KERNEL_MAP                           = 0xfffffff0075ec050;
            OFFSET_KERNEL_TASK                          = 0xfffffff0075ec048;
            OFFSET_REALHOST                             = 0xfffffff007572ba0;
            OFFSET_BZERO                                = 0xfffffff0070c1f80;
            OFFSET_BCOPY                                = 0xfffffff0070c1dc0;
            OFFSET_COPYIN                               = 0xfffffff0071c5db4;
            OFFSET_COPYOUT                              = 0xfffffff0071c6094;
            OFFSET_IPC_PORT_ALLOC_SPECIAL               = 0xfffffff0070deff4;
            OFFSET_IPC_KOBJECT_SET                      = 0xfffffff0070f22cc;
            OFFSET_IPC_PORT_MAKE_SEND                   = 0xfffffff0070deb18;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB         = 0xfffffff006e49208 + 0x1030;
            // OFFSET_ROP_ADD_X0_X0_0x10                   = 0xfffffff0063c5398;
            OFFSET_ROP_ADD_X0_X0_0x10                   = 0xfffffff0064fb0a8;
        }
        
        //10.3.2
        if(!strcmp(version, "14F89"))
        {
            OFFSET_ZONE_MAP                             = 0xfffffff007590478;
            OFFSET_KERNEL_MAP                           = 0xfffffff0075ec050;
            OFFSET_KERNEL_TASK                          = 0xfffffff0075ec048;
            OFFSET_REALHOST                             = 0xfffffff007572ba0;
            OFFSET_BZERO                                = 0xfffffff0070c1f80;
            OFFSET_BCOPY                                = 0xfffffff0070c1dc0;
            OFFSET_COPYIN                               = 0xfffffff0071c6108;
            OFFSET_COPYOUT                              = 0xfffffff0071c63e8;
            OFFSET_IPC_PORT_ALLOC_SPECIAL               = 0xfffffff0070deff4;
            OFFSET_IPC_KOBJECT_SET                      = 0xfffffff0070f22cc;
            OFFSET_IPC_PORT_MAKE_SEND                   = 0xfffffff0070deb18;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB         = 0xfffffff006e49208 + 0x1030;
            OFFSET_ROP_ADD_X0_X0_0x10                   = 0xfffffff0065000a8;
        }
        
        //10.3.1
        if(!strcmp(version, "14E304"))
        {
            OFFSET_ZONE_MAP                             = 0xfffffff007590478;
            OFFSET_KERNEL_MAP                           = 0xfffffff0075ec050;
            OFFSET_KERNEL_TASK                          = 0xfffffff0075ec048;
            OFFSET_REALHOST                             = 0xfffffff007572ba0;
            OFFSET_BZERO                                = 0xfffffff0070c1f80;
            OFFSET_BCOPY                                = 0xfffffff0070c1dc0;
            OFFSET_COPYIN                               = 0xfffffff0071c6134;
            OFFSET_COPYOUT                              = 0xfffffff0071c6414;
            OFFSET_IPC_PORT_ALLOC_SPECIAL               = 0xfffffff0070df05c;
            OFFSET_IPC_KOBJECT_SET                      = 0xfffffff0070f22b4;
            OFFSET_IPC_PORT_MAKE_SEND                   = 0xfffffff0070deb80;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB         = 0xfffffff006e49208 + 0x1030;
            OFFSET_ROP_ADD_X0_X0_0x10                   = 0xfffffff0064ff0a8;
        }
        
        //10.3
        if(!strcmp(version, "14E277"))
        {
            LOG("10.3 - 14E277 offsets not found for %s", device);
            exit(1);
        }
        
        
    }
    
    //iPhone 7 Plus
    else if(!strcmp(device, "iPhone9,4") || !strcmp(device, "iPhone9,2"))
    {
        //10.3.3
        if(!strcmp(version, "14G60"))
        {
            OFFSET_ZONE_MAP                             = 0xfffffff007590478;
            OFFSET_KERNEL_MAP                           = 0xfffffff0075ec050;
            OFFSET_KERNEL_TASK                          = 0xfffffff0075ec048;
            OFFSET_REALHOST                             = 0xfffffff007572ba0;
            OFFSET_BZERO                                = 0xfffffff0070c1f80;
            OFFSET_BCOPY                                = 0xfffffff0070c1dc0;
            OFFSET_COPYIN                               = 0xfffffff0071c5db4;
            OFFSET_COPYOUT                              = 0xfffffff0071c6094;
            OFFSET_IPC_PORT_ALLOC_SPECIAL               = 0xfffffff0070deff4;
            OFFSET_IPC_KOBJECT_SET                      = 0xfffffff0070f22cc;
            OFFSET_IPC_PORT_MAKE_SEND                   = 0xfffffff0070deb18;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB         = 0xfffffff006e49208 + 0x1030;
            // OFFSET_ROP_ADD_X0_X0_0x10                   = 0xfffffff0063c5398;
            OFFSET_ROP_ADD_X0_X0_0x10                   = 0xfffffff0064fb0a8;
        }
        
        //10.3.2
        if(!strcmp(version, "14F89"))
        {
            OFFSET_ZONE_MAP                             = 0xfffffff007590478;
            OFFSET_KERNEL_MAP                           = 0xfffffff0075ec050;
            OFFSET_KERNEL_TASK                          = 0xfffffff0075ec048;
            OFFSET_REALHOST                             = 0xfffffff007572ba0;
            OFFSET_BZERO                                = 0xfffffff0070c1f80;
            OFFSET_BCOPY                                = 0xfffffff0070c1dc0;
            OFFSET_COPYIN                               = 0xfffffff0071c6108;
            OFFSET_COPYOUT                              = 0xfffffff0071c63e8;
            OFFSET_IPC_PORT_ALLOC_SPECIAL               = 0xfffffff0070deff4;
            OFFSET_IPC_KOBJECT_SET                      = 0xfffffff0070f22cc;
            OFFSET_IPC_PORT_MAKE_SEND                   = 0xfffffff0070deb18;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB         = 0xfffffff006e49208 + 0x1030;
            // OFFSET_ROP_ADD_X0_X0_0x10                   = 0xfffffff0063ca398;
            OFFSET_ROP_ADD_X0_X0_0x10                   = 0xfffffff0065000a8;
        }
        
        //10.3.1
        if(!strcmp(version, "14E304"))
        {
            OFFSET_ZONE_MAP                             = 0xfffffff007590478;
            OFFSET_KERNEL_MAP                           = 0xfffffff0075ec050;
            OFFSET_KERNEL_TASK                          = 0xfffffff0075ec048;
            OFFSET_REALHOST                             = 0xfffffff007572ba0;
            OFFSET_BZERO                                = 0xfffffff0070c1f80;
            OFFSET_BCOPY                                = 0xfffffff0070c1dc0;
            OFFSET_COPYIN                               = 0xfffffff0071c6134;
            OFFSET_COPYOUT                              = 0xfffffff0071c6414;
            OFFSET_IPC_PORT_ALLOC_SPECIAL               = 0xfffffff0070df05c;
            OFFSET_IPC_KOBJECT_SET                      = 0xfffffff0070f22b4;
            OFFSET_IPC_PORT_MAKE_SEND                   = 0xfffffff0070deb80;
            OFFSET_IOSURFACEROOTUSERCLIENT_VTAB         = 0xfffffff006e49208 + 0x1030;
            // OFFSET_ROP_ADD_X0_X0_0x10                   = 0xfffffff0063c9398;
            OFFSET_ROP_ADD_X0_X0_0x10                   = 0xfffffff0064ff0a8;
        }
        
        //10.3
        if(!strcmp(version, "14E277"))
        {
            LOG("10.3 - 14E277 offsets not found for %s", device);
            exit(1);
        }
        
        
    }
    
    //iPod touch 6
    else if(!strcmp(device, "iPod7,1"))
    {
        //10.3.3
        if(!strcmp(version, "14G60"))
        {
            LOG("10.3.3 - 14G60 offsets not found for %s", device);
            exit(1);
        }
        
        //10.3.2
        if(!strcmp(version, "14F89"))
        {
            LOG("10.3.2 - 14F89 offsets not found for %s", device);
            exit(1);
        }
        
        //10.3.1
        if(!strcmp(version, "14E304"))
        {
            LOG("10.3.1 - 14E304 offsets not found for %s", device);
            exit(1);
        }
        
        //10.3
        if(!strcmp(version, "14E277"))
        {
            LOG("10.3 - 14E277 offsets not found for %s", device);
            exit(1);
        }
        
        
    }
     
    else
    {
        LOG("Device not supported.");
        return FALSE;
    }
    LOG("%s", kern_version);
    LOG("loading offsets for %s - %s", device, version);
    LOG("test offset x0x0x10gadget: %llx", OFFSET_ROP_ADD_X0_X0_0x10);
    return TRUE;
}

