freeze-homedirs
=================
I took the excellent script from [Deploy Studio](http://www.deploystudio.com/) and tweaked it to allow for more selective home directory "freezing". I also made a handy [luggage](https://github.com/unixorn/luggage) makefile to package it all up for easy deployment.

To use:
--------
* Install script and launchdaemon plist. (Use the luggage makefile for a handy .pkg)
* ```touch /Users/username/.dss.enable.backup``` to "freeze" the home directory on the next boot.
* Need to change something? Do it. Then, just delete the backup folder (```/private/dss_homedirs_ref/username```) *or* ```touch /private/dss_homedirs_ref/username/.dss.update.backup```
* Reboot.
* Profit.

How
--------
The script runs at boot and uses ditto to create a backup of the home directory if no backup exists and it sees the flag. Then, on each subsequent boot, checks to see if it needs to update the backup and uses rsync to restore the original state of any files that changed.

Why
--------
We needed to freeze a some local accounts but not everything else, like installed applications, system settings (a la Deep Freeze) or network user's home folders. Changing the script to an opt-in model instead of opt-out made this possible.