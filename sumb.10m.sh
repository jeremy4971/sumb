#!/bin/bash
# shellcheck disable=SC2140 # double quotes related
# shellcheck disable=SC2003 # expr related

######################################################################
# Script provided AS IS and created as proof of concept for blogpost #
# https://clementine.la/scripts/scheduled-updates-menu-bar-sumb/     #
# Option + click on menu icon to show all the hidden settings        #
# Icon by Freepik                                                    #
######################################################################

# SwiftBar settings
# <swiftbar.hideAbout>true</swiftbar.hideAbout>
# <swiftbar.hideRunInTerminal>true</swiftbar.hideRunInTerminal>
# <swiftbar.hideLastUpdated>true</swiftbar.hideLastUpdated>
# <swiftbar.hideDisablePlugin>true</swiftbar.hideDisablePlugin>
# <swiftbar.hideSwiftBar>true</swiftbar.hideSwiftBar>

# Base64 icons
IconBase64="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"
InstallButtonBase64="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"

# Reading plist
PlistBuddy="/usr/libexec/PlistBuddy"
totalCount=$($PlistBuddy -c "print :totalCount" /Users/Shared/sumb/app.sumb.managedsoftwareupdate.plist)
arrayNum=$(expr "$totalCount" - 1)
maxDeferrals=$($PlistBuddy -c "print :results:$arrayNum:maxDeferrals" /Users/Shared/sumb/app.sumb.managedsoftwareupdate.plist)
deferralsRemaining=$($PlistBuddy -c "print :results:$arrayNum:deferralsRemaining" /Users/Shared/sumb/app.sumb.managedsoftwareupdate.plist)
nextScheduledInstall=$($PlistBuddy -c "print :results:$arrayNum:nextScheduledInstall" /Users/Shared/sumb/app.sumb.managedsoftwareupdate.plist | cut -c-16)
nextScheduledInstall2=${nextScheduledInstall/T/ · }
status=$($PlistBuddy -c "print :results:$arrayNum:status" /Users/Shared/sumb/app.sumb.managedsoftwareupdate.plist)
downloadPercentComplete=$($PlistBuddy -c "print :results:$arrayNum:downloadPercentComplete" /Users/Shared/sumb/app.sumb.managedsoftwareupdate.plist)
downloadPercentComplete2=$(awk "BEGIN {printf \"%.2f %%\", $downloadPercentComplete * 100}")
productKey=$($PlistBuddy -c "print :results:$arrayNum:productKey" /Users/Shared/sumb/app.sumb.managedsoftwareupdate.plist | sed 's/^MSU_UPDATE_//')
dateModified=$(date -r /Users/Shared/sumb/app.sumb.managedsoftwareupdate.plist "+%Y-%m-%d · %H:%M")
JSSID=$(defaults read "/Users/Shared/sumb/jssid.plist" JSSID)

# SwiftBar Menu
if [ "$totalCount" -eq 0 ] || [ "$nextScheduledInstall" = "999" ]; then
	echo "|templateImage=$IconBase64"
elif [ "$totalCount" -ge 1 ]; then
	echo "D-$deferralsRemaining | font=HelveticaNeue-Bold color=red templateImage=$IconBase64"
else
	echo "? | font=HelveticaNeue-Bold color=black templateImage=$IconBase64"
	echo "---"
	echo "Error"
	exit 0
fi

# SwiftBar Submenus
echo "---"
if [ "$totalCount" -eq 0 ] || [ "$nextScheduledInstall" = "999" ]; then
	echo "No macOS update scheduled| size=14 font=HelveticaNeue-Bold terminal=false bash="/Users/Shared/sumb/open_softwareupdate.sh""
	echo "---"
	echo "Last API request : $dateModified · $JSSID | size=13 font=HelveticaNeue-Regular"
	exit 0
elif [ "$totalCount" -ge 1 ]; then
	echo "macOS Update available| size=14 font=HelveticaNeue-Bold terminal=false bash="/Users/Shared/sumb/open_softwareupdate.sh""
	echo "| terminal=false bash="/Users/Shared/sumb/open_softwareupdate.sh" image=$InstallButtonBase64"
fi
echo "---"
echo "Status : $status | size=13 font=HelveticaNeue-Regular terminal=false bash="/Users/Shared/sumb/open_softwareupdate.sh""
echo "Download : $downloadPercentComplete2 | size=13 font=HelveticaNeue-Regular terminal=false bash="/Users/Shared/sumb/open_softwareupdate.sh""
echo "Allowed Deferrals : $deferralsRemaining of $maxDeferrals remaining | size=13 font=HelveticaNeue-Regular terminal=false bash="/Users/Shared/sumb/open_softwareupdate.sh"" 
echo "Next Install Attempt : $nextScheduledInstall2 | size=13 font=HelveticaNeue-Regular terminal=false bash="/Users/Shared/sumb/open_softwareupdate.sh""
echo "Product Key : $productKey| size=13 font=HelveticaNeue-Regular terminal=false bash="/Users/Shared/sumb/open_softwareupdate.sh""
echo "---"
echo "Last API request : $dateModified · $JSSID| size=13 font=HelveticaNeue-Regular"

exit 0
