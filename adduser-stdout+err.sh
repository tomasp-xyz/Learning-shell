#!/bin/bash

# 1 - check for user to be root, otherwise throw stderr

if [[ $UID -ne 0 ]]
then
	echo "Your UID is $UID, please run this script as root" >&2
	exit 1
	else
	echo "Your UID is $UID, you are root. Proceeding..."
	echo
fi

# 2 - Provide usage statement if username is not entered  and return exit 1 status
if [[ $# -lt 1 ]]
then
	echo "To use this script, enter desired [USERNAME] and [DESCRIPTION]..." >&2
	echo "In addition, specify comment and/or description of the account" >&2
	exit 1
fi

# 3 - define username parameter
USERNAME=$1

#Other parameters are for account comments
shift
comment="$@"

# Generate password
PASSWORD=$(date +%sn%N${RANDOM}${RANDOM} | sha256sum | head -c16)

#Add user with description
useradd -c $COMMENT -m $USERNAME &> /dev/null

#Warn and exit if account couldn't be created
if [[ $? -ne 0 ]]
then
	echo "The account couldn't be created, exit status $?" >&2
	exit 1
fi

#Enter password for the new user using stdin
echo $PASSWORD | passwd --stdin $USERNAME &> /dev/null

#Check if passwd succeeded
if [[ $? -ne 0 ]]
then
	echo "Failed to set password for $USERNAME, please try again" >&2
	echo "Exit status $?" >&2
	exit 1
fi

#Force password change for newly created user
passwd -e $USERNAME &> /dev/null

#Display newly created info about user
if [[ $? -eq 0 ]]
then
	>&1 echo "Created new user with the following parameters:"
	>&1 echo
	>&1 echo "Username: $USERNAME"
	>&1 echo
	>&1 echo "Description: $COMMENT"
	>&1 echo	
	>&1 echo "Password: $PASSWORD"
	>&1 echo
	>&1 echo "Hostname of the local machine: $(hostname)"
	>&1 echo
	>&1 echo "Date of creation: $(date)"
fi

exit 0
