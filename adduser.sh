#!/bin/bash

#Script to add local users, with extra functionalities
#Integrated the following checks:
#1. Check if user, running this script, has root priviliges
#1.1 - if user has root then proceed with script
#1.2 - if user doesn't have root then terminate script with exit 1 status

#2. Prompt the person who executed this script for:
#2.1 - username
#2.2 - name of the person
#2.3 - password

#3. If account fails to be created, exit with status 1. If exit status is 0 - create account 

#4. If account has been created, display all entered info as a final output
#4.1 - in addition, display hostname where the account was created

#-----#

#1. Check for root priviliges
if [[ "${UID}" -eq 0 ]] 
then
	echo 'UID of' $(id -u) 'detected, you are root'
	else
	echo 'UID of' $(id -u) 'is not equal to 0! You are not root'
	exit 1
fi

# Define username var
read -p 'Enter username: ' USERNAME

read -p 'Enter name of the person: ' DESCRIPTION

# Create account, check if account is created, if not then exit 1
useradd -m ${USERNAME} -c "${DESCRIPTION}"

if [[ "${?}" -eq 0 ]]
then
	echo 'Username OK, proceed with password...'
	else
	echo 'Bad username, exit status 1, try again...'
	exit 1
fi

# Submit password for this account

read -p 'Enter password of the new account: ' PASSWORD
echo ${PASSWORD} | passwd --stdin ${USERNAME} 

if [[ "${?}" -eq 0 ]]
then
	echo 'Password OK, forcing to change password on logon...'
	passwd -e ${USERNAME}
	else
	echo 'Password field is invalid, exiting.'
	exit 1
fi

#Display info about newly created account+hostname
echo 'Created new user with the following parameters: '
echo
echo 'Username - ' ${USERNAME}
echo
echo 'Name - ' ${DESCRIPTION}
echo
echo 'Password - ' ${PASSWORD}
echo
echo 'Hostname of the device at the time of account creation: ' $(hostname)
