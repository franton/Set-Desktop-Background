#!/bin/bash

# Script to set desktop background

# Author : contact@richard-purves.com
# Version 1.0 : Initial Version
# Version 1.1 : 23/04/2014 - Massive reworking to use applescript for 10.8 and below, modify the db for 10.9+

# This script checks parameter 4 being passed from Casper. If it's set to "custom", you get the custom wallpaper.
# If not, you get the standard one.

# 10.8 or lower, we use an osascript call to make the wallpaper change running as current logged in user
# 10.9 or higher, we're directly manipulating the desktoppicture.db database and then killing the dock

# Please note that the database does NOT need the spaces escaped from the file path
# The osascript command DOES need the spaces escaped!

# Get variables here, such as OS major version and currently logged in user
OSversion=$( sw_vers | grep ProductVersion: | cut -c 20-20 )
currentuser=$( ls -l /dev/console | awk '{print $3}' )

if [ "$4" = "custom" ];
then

if [[ "$OSversion" -ge "9" ]];
then

sqlite3 /Users/$currentuser/Library/Application\ Support/Dock/desktoppicture.db << EOF
UPDATE data SET value = "/Users/Shared/Background/custom.jpeg";
.quit
EOF
	
killall Dock

else
su -l $currentuser -c 'osascript -e "tell application \"System Events\" to set picture of every desktop to \"/Users/Shared/Background/custom.jpeg\""'
fi

else

if [[ "$OSversion" -ge "9" ]];
then

sqlite3 /Users/$currentuser/Library/Application\ Support/Dock/desktoppicture.db << EOF
UPDATE data SET value = "/Library/Desktop Pictures/default_grey2560x1600.jpeg";
.quit
EOF

killall Dock

else
su -l $currentuser -c 'osascript -e "tell application \"System Events\" to set picture of every desktop to \"/Library/Desktop\ Pictures/default_grey2560x1600.jpeg\""'
fi

fi
exit 0
