Download script to the following directory: jffs/scripts of the AiMesh node having issues trying to broadcast 6GHz with the 3006 parent router:
curl --retry 3 "https://raw.githubusercontent.com/ViktorJp/RTRMON/develop/rtrmon.sh" -o "/jffs/scripts/6GFix.sh" && chmod 755 "/jffs/scripts/6GFix.sh"

#For Merlin Firmware:
**Add:** sh /jffs/scripts/6GFix.sh 
**To:** post-mount
Make sure to set the script permissions are set to: 755

#For Stock Firmware:
Add the script to: asusware.arm/etc/init.d/S50usb-mount-script
cru a 6GHzWatchdog "1-59/5 * * * * /bin/sh /jffs/scripts/6GFix.sh"
Make sure to set the script permissions are set to: 755

Info here: https://www.snbforums.com/threads/asus-rt-ax3000-firmware-version-3-0-0-4-388-23403-2023-05-31.85267/#post-846078
