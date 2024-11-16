**Step 1: Download**
- Download script to the following directory: `jffs/scripts` of the AiMesh node having issues trying to broadcast 6GHz with the 3006 parent router:
`curl --retry 3 "https://raw.githubusercontent.com/ExtremeFiretop/3006.102-6GHzFix/main/6GFix.sh" -o "/jffs/scripts/6GFix.sh" && chmod 755 "/jffs/scripts/6GFix.sh"`
##
**Step 2: Setup**
**-For Merlin Firmware:**
**Add:** `sh /jffs/scripts/6GFix.sh &`
**To:** `/jffs/scripts/services-start`

Example below:
`[ -f /jffs/scripts/6GFix.sh ] && sh /jffs/scripts/6GFix.sh & # Added by ExtremeFiretop`

Make sure to set the script permissions are set to: 755

**-For Stock Firmware:**
**Add:** `sh /jffs/scripts/6GFix.sh &`
**To:** `asusware.arm/etc/init.d/S50usb-mount-script`

Example below:
`[ -f /jffs/scripts/6GFix.sh ] && sh /jffs/scripts/6GFix.sh & # Added by ExtremeFiretop`

cru a 6GHzWatchdog "1-59/5 * * * * /bin/sh /jffs/scripts/6GFix.sh"

-Make sure to set the script permissions are set to: 755
-More Info here: https://www.snbforums.com/threads/asus-rt-ax3000-firmware-version-3-0-0-4-388-23403-2023-05-31.85267/#post-846078
