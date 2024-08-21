Download script to the following directory: jffs/scripts of the AiMesh node having issues trying to broadcast 6GHz with the 3006 parent router:

curl --retry 3 "https://raw.githubusercontent.com/ViktorJp/RTRMON/develop/rtrmon.sh" -o "/jffs/scripts/6GFix.sh" && chmod 755 "/jffs/scripts/6GFix.sh"

**Add:** sh /jffs/scripts/6GFix.sh **To:** post-mount

Make sure to set the script permissions are set to: 755
