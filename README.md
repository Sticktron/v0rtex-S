# v0rtex-S

A partial jailbreak for iOS 10.3.x based on Siguza's [v0rtex](https://github.com/Siguza/v0rtex) kernel exploit.


## What you get

- tfp0
- kernel memory r/w
- system partition r/w
- AMFI/codesigning patch
- Dropbear SSH server listening on port 2222
- helpful pack of command line tools


## Screenshot

<img width="375" src="screenshot.png" alt="Screenshot"/>


## Offsets

Currently includes offsets for:

- iPhone9,3 (iPhone 7) on iOS 10.3.1
- iPhone8,1 (iPhone 6S) on 10.3.2

To find your own offsets read [this guide](https://gist.github.com/uroboro/5b2b2b2aa1793132c4e91826ce844957).

There are a few new offsets you will need to find:

**OFFSET_ROOT_MOUNT_V_NODE**: ```nm <kernelcache> | grep -E " _rootvnode$"```

**OFFSET_CHGPROCCNT**: This offset references the string ```"chgproccnt: lost user"```

**OFFSET_ROP_LDR_X0_X0_0x10**: Simply search for ```000840f9c0035fd6``` in hex.

**OFFSET_KAUTH_CRED_REF**: This can be found in the symbols table ```nm <kernelcache> | grep kauth_cred_ref```


## Credits

This project features work from a variety of people, mainly siguza and xerub, but also other people who's names will show up here at some point.
