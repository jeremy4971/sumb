#!/bin/bash

# Read logged-in user
CURRENT_USER=$(scutil <<< "show State:/Users/ConsoleUser" | awk '/Name :/ && ! /loginwindow/ { print $3 }')

# SwiftBar Settings
sudo -u "$CURRENT_USER" defaults write /Users/$CURRENT_USER/Library/Preferences/com.ameba.SwiftBar.plist "DimOnManualRefresh" -bool false
sudo -u "$CURRENT_USER" defaults write /Users/$CURRENT_USER/Library/Preferences/com.ameba.SwiftBar.plist "PluginDirectory" -string "/Users/Shared/sumb/swiftbar"
sudo -u "$CURRENT_USER" defaults write /Users/$CURRENT_USER/Library/Preferences/com.ameba.SwiftBar.plist "SUEnableAutomaticChecks" -bool false
sudo -u "$CURRENT_USER" defaults write /Users/$CURRENT_USER/Library/Preferences/com.ameba.SwiftBar.plist "SUHasLaunchedBefore" -bool true
sudo -u "$CURRENT_USER" defaults write /Users/$CURRENT_USER/Library/Preferences/com.ameba.SwiftBar.plist "SUSendProfileInfo" -bool false

# Add SWiftBar to login items
#osascript -e 'tell application "System Events" to make login item at end with properties {name: "SwiftBar",path:"/Applications/SwiftBar.app", hidden:false}'

# Restart cfprefsd
killall cfprefsd

# Change owner
chown -R "$CURRENT_USER" "/Applications/SwiftBar.app"

# Open SwiftBar
open "/Applications/SwiftBar.app"
