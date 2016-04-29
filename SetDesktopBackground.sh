#!/bin/bash

# Script to set desktop background

# Author : contact@richard-purves.com
# Version 1.0 : Initial Version
# Version 1.1 : 23/04/2014 - Massive reworking to use applescript for 10.8 and below, modify the db for 10.9+
# Version 2.0 : 29/04/2016 - Another massive reworking taking the fork of this script into consideration.
# That fork is https://github.com/SeanHansell/Casper-Change-Desktop/blob/master/SetDesktopBackground.sh
# And Sean Hansell <sean@morelen.net> deserves massive kudos for fixing some of the issues I didn't have time to do.

# Get variables here, such as OS major version and currently logged in user

custombg="/Users/Shared/custombg.jpg"
stdbg="location/Desktop.jpg"

os_version=$( sw_vers | grep ProductVersion: | awk '{print $2}' | sed 's/\./\ /g' | awk '{print $2}' )

current_user=$( python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");' )
current_user_home=$( dscl . -read "/Users/${current_user}" NFSHomeDirectory | sed 's/NFSHomeDirectory\:\ //' )

desktop_db="${current_user_home}/Library/Application Support/Dock/desktoppicture.db"
desktop_domain="${current_user_home}/Library/Preferences/com.apple.desktop"
desktop_plist="${desktop_domain}.plist"

# Create the log file

LOGFOLDER="/Users/$loggedInUser/Library/Logs/"
LOG=$LOGFOLDER/desktop-background.log

if [ ! -d "$LOGFOLDER" ]; then
	mkdir $LOGFOLDER
fi

# Start the log file

echo $( date )" - Desktop Background Script" > $LOG

if [ -f "$custombg" ];
then
	echo $( date )" - Using custom desktop background" > $LOG
	desktop_picture="$custombg"
else
	echo $( date )" - Using standard desktop background" > $LOG
	desktop_picture="$stdbg"
fi

if (( $os_version > 8 ))
then
	echo $( date )" - OS X version greater than 10.8. Using sqlite method." > $LOG
	sqlite3 "${desktop_db}" << EOF
UPDATE data SET value = "${desktop_picture}";
.quit
EOF
else
	echo $( date )" - OS X version lower than 10.8. Using defaults method." > $LOG
	defaults delete "${desktop_domain}" Background
	defaults write "${desktop_domain}" Background '{default = {ImageFilePath = "'"${desktop_picture}"'";};}'
	chown "${current_user}" "${desktop_plist}" # Previous commands change ownership to root. Maintaining ownership.
fi

killall Dock

echo $( date )" - Script complete." > $LOG
exit 0
