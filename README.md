# v0rtex-S

A very basic App for testing Siguza's [v0rtex](https://github.com/Siguza/v0rtex) kernel exploit.

This fork also includes r/w access to / (aka disk0s1s1), on top of the previously given r/w access to /var.

Fat creds to stek on the r/w stuff, and originally xerub too. 

### Offsets

The offsets used are for iPhone 7 on iOS 10.3.1 and must be changed if that's not what you're using.

Offsets for iPod 6G (iPod7,1) 10.3.3, iPhone 7 (iPhone9,1) 10.3.3 and iPhone 6S (iPhone8,1) 10.3.2 are also included, however you will have to be a big boy and switch them out yourself in the v0rtex.m file.

To find your own offsets read [this guide](https://gist.github.com/uroboro/5b2b2b2aa1793132c4e91826ce844957).

You may also need to find the OFFSET_ROOT_MOUNT_V_NODE offset, which was added with the root r/w capability. To find the offset, first get a decrypted version of your kerelcache. Then use the following command:

```nm <kernelcache> | grep -E " _rootvnode$"```

Example output:

```Bens-MBP:i71031Original Ben$ nm kernelcache | grep _rootvnode
fffffff0075ec0b0 S _rootvnode
```

Make sure to add a '0x' to the start of the address too:

`0xfffffff0075ec0b0`

### Requirements

Xcode and a device running iOS 10.3.x.
