#!/bin/bash

#  Modified 2014-10-31
#  delete_inactive_users.sh
#  Maintained at https://github.com/dankeller/macscripts
#  by Dan Keller
#
#  MIT License
#
#======================================
#
#  Script to delete local user data that has not been accessed in a given time
#  period.
#
#  This script scans the /Users folder for the date last updated (logged in)
#  and deletes the folder as well as the corresponding user account if it has
#  been longer than the tiome specified. You can specify user folders to keep as
#  well.
#
#  User data not stored in /Users is not effected.
#
#  Helpful for maintaing shared/lab Macs connected to an AD/OD/LDAP server.
#
#======================================


#----Variables----
AGE=90	# Delete /User/ folders inactive longer than this many days

KEEP=("/Users/Shared" "/Users/support" "/Users/student" "/Users/testing") # User folders you would like to bypass. Typically local users or admin accounts.
#--End variables--


### Delete Inactive Users ###
if [[ $UID -ne 0 ]]; then echo "$0 must be run as root." && exit 1; fi

USERLIST=`/usr/bin/find /Users -type d -maxdepth 1 -mindepth 1 -not -name "." -mtime +$AGE`

echo "Performing inactive user cleanup"

for a in $USERLIST; do
	if ! [[ ${KEEP[*]} =~ "$a" ]]; then
		echo "Deleting inactive (over $AGE days) account and home directory:" $a
		
		# delete user
		/usr/bin/dscl . delete $a > /dev/null 2>&1
		
		# delete home folder
		/bin/rm -r $a
		continue
	else
		echo "SKIPPING" $a
	fi
done

echo "Cleanup complete"
exit 0
