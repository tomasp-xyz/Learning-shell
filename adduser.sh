#!/bin/bash

# simple script to create an account on a local system, will ask for username, description and password input

#Ask for username
read -p 'Enter username to create: ' USER_NAME

#Ask for description of account
read -p 'Enter name of the person for this account: ' COMMENT

#Ask for password
read -p 'Enter password for the account: ' PASSWORD

#Create user
useradd -c "${COMMENT}" -m ${USER_NAME}

#Set password for new user
echo ${PASSWORD} | passwd --stdin ${USER_NAME}

#Force user to change pass on first login
passwd -e ${USER_NAME}
