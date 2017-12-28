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

kern_return_t v0rtex(task_t *tfp0, kptr_t *kslide, kptr_t *kernucred, kptr_t *selfproc);

#endif
