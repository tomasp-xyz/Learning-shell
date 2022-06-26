#!/bin/bash

#1. Check for root priviliges
if [[ "${UID}" -eq 0 ]] 
then
	echo 'UID of' $(id -u) 'detected, you are root'
	else
	echo 'UID of' $(id -u) 'is not equal to 0! You are not root'
	exit 1
fi

#Print help if username fails
if [[ $# -lt 1 ]]
then
	echo 'Usage: $0 USERNAME [COMMENT]...'
	echo 'Create an account on the local system with the name of USERNAME and a comments field of COMMENT.'
	exit 1
fi

# First parameter is username
USERNAME=$1

# The rest of the parameters are for account comments
shift
COMMENT="$@"
	
# Generate password, randomized based on date+sha checksum, 16chars

echo 'Generating random password...'
echo
PASSWORD=$(date +%sn%N | sha256sum | head -c16)

#Create user with username, comment
useradd -c "$COMMENT" -m $USERNAME

# Check for return status
if [[ $? -ne 0 ]]
then
	echo 'The account could not be created.'
	exit 1
fi

echo $PASSWORD | passwd --stdin $USERNAME

# Check if passwd succeeded
if [[ $? -ne 0 ]]
then
	echo 'The password could not be set'
	exit 1
fi

#Force password change
passwd -e $USERNAME

#Display info about newly created account+hostname
echo 'Created new user with the following parameters: '
echo
echo 'Username - ' ${USERNAME}
echo
echo 'Name - ' $COMMENT
echo
echo 'Password - ' ${PASSWORD}
echo
echo 'Hostname of the device at the time of account creation: ' $(hostname)
exit 0

