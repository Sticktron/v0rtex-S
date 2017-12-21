# v0rtex-S

A work in progress jailbreak, using Sigzua's [v0rtex](https://github.com/Siguza/v0rtex) kernel exploit.

Currently, we have:
 - r/w kernel access
 - r/w on '/' (root dir, aka disks1s1)
 - AMFI/codesigning patch, hence the ability to run unsigned code
 - SSH access (with included binaries)

Fat creds to stek on the r/w stuff, and originally xerub too. 

### Offsets

Offsets are currently WIP. We will be updating with new offsets for as many devices as possible ASAP.

The offsets used are for iPhone 7 on iOS 10.3.1 and must be changed if that's not what you're using.

Offsets for iPhone 6S (iPhone8,1) 10.3.2 are also included, however you will have to be a big boy and switch them out yourself in the v0rtex.m file.

To find your own offsets read [this guide](https://gist.github.com/uroboro/5b2b2b2aa1793132c4e91826ce844957).

There are a few new offsets you will need to find:

**OFFSET_ROOT_MOUNT_V_NODE**: ```nm <kernelcache> | grep -E " _rootvnode$"```

**OFFSET_CHGPROCCNT**: This offset references the string ```"chgproccnt: lost user"```

**OFFSET_ROP_LDR_X0_X0_0x10**: Simply search for ```000840f9c0035fd6``` in hex.

**OFFSET_KAUTH_CRED_REF**: This can be found in the symbols table ```nm <kernelcache> | grep kauth_cref_ref```

### Requirements

Xcode and a device running iOS 10.3.x.
