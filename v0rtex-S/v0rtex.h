#ifndef V0RTEX_H
#define V0RTEX_H

#include <mach/mach.h>

#include "common.h"

#define SIZEOF_TASK                                 0x550
#define OFFSET_TASK_ITK_SELF                        0xd8
#define OFFSET_TASK_ITK_REGISTERED                  0x2e8
#define OFFSET_TASK_BSD_INFO                        0x360
#define OFFSET_PROC_P_PID                           0x10
#define OFFSET_PROC_UCRED                           0x100
#define OFFSET_UCRED_CR_UID                         0x18
#define OFFSET_UCRED_CR_LABEL                       0x78
#define OFFSET_VM_MAP_HDR                           0x10
#define OFFSET_IPC_SPACE_IS_TASK                    0x28
#define OFFSET_REALHOST_SPECIAL                     0x10
#define OFFSET_IOUSERCLIENT_IPC                     0x9c
#define OFFSET_VTAB_GET_EXTERNAL_TRAP_FOR_INDEX     0x5b8
#define OFFSET_P_CSFLAGS                            0x2a8
#define OFFSET_P_CPUTYPE                            0x2c0
#define OFFSET_P_CPU_SUBTYPE                        0x2c4
#define OFFSET_P_TEXTVP                             0x248
#define OFFSET_P_TEXTOFF                            0x248
#define OFFSET_V_TYPE                               0x70
#define OFFSET_V_UBCINFO                            0x78
#define OFFSET_UBCINFO_CSBLOBS                    0x50
#define OFFSET_CSB_CPUTYPE                          0x8
#define OFFSET_CSB_FLAGS                            0x12
#define OFFSET_CSB_BASE                             0x16
#define OFFSET_CSB_ENTITLEMENTS                     0x98
#define OFFSET_CSB_SIGNER_TYPE                       0xA0
#define OFFSET_CSB_PLATFORM_BINARY                  0xA4
#define OFFSET_CSB_PLATFORM_PATH                    0xA8

kern_return_t v0rtex(task_t *tfp0, kptr_t *kslide, kptr_t *kernucred, kptr_t *selfproc);

#endif
