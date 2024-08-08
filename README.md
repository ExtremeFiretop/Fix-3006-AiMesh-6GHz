Download script to jffs/scripts directory: 
curl --retry 3 "https://raw.githubusercontent.com/ViktorJp/RTRMON/develop/rtrmon.sh" -o "/jffs/scripts/6GFix.sh" && chmod 755 "/jffs/scripts/6GFix.sh"

**Add:** sh /jffs/scripts/6GFix.sh

**To:** post-mount

Make sure to set the script permissions are set to: 755
