Set Desktop Background
----------------------

This script checks parameter 4 being passed from Casper. If it's set to "custom", you get the custom wallpaper.
If not, you get the standard one.

10.8 or lower, we use an osascript call to make the wallpaper change running as current logged in user
10.9 or higher, we're directly manipulating the desktoppicture.db database and then killing the dock

Please note that the database does NOT need the spaces escaped from the file path
The osascript command DOES need the spaces escaped!