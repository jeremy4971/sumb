# Scheduled Updates Menu Bar, aka SUMB (Jamf only)
I made something I call the NoMAD menu for macOS updates. It provides information about the status of an MDM scheduled update and the remaining number of allowed deferrals before the Mac force-installs a system update.

The recommended method by Apple or Jamf for mass updates with user deferrals is not clear as to why the MDM command often fails. It could be related to network issues, disk space, or even battery status. I’m aware of cool tools like Nudge or SUPER, which I have used in the past with great results! However, I find them a bit challenging to set up correctly, and they don’t work in conjunction with the MDM update command.

To address this, I came up with a solution ‘set once & forget it’ called the Scheduled Updates Menu Bar (SUMB). It’s essentially a plugin for the open-source app SwiftBar. There are no notifications to bother the users. Instead, think of it as a constant nudging in the toolbar with an ugly red countdown. Additionally, SUMB leverages the Jamf APIs, so you need to be using this MDM.

SUMB is provided ‘AS IS’ and serves more as a proof of concept than anything else. I don’t plan to maintain it, so feel free to copy, modify, or share it with or without attribution—I don’t mind. My hope is that it will inspire someone to develop a real application based on this idea.
