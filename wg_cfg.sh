#!/bin/bash

#Check for sudo

if [[ $UID -ne 0 ]]
then
	echo "Please run this script with superuser privileges (sudo)" >&2
	exit 1
fi

#Check if WG is installed
while $(dpkg -s wireguard &> /dev/null) ; [[ $? -ne 0 ]]; do
	read -p "WireGuard package is not installed. Do you wish to install it now? (y/n) " yn
	case $yn in
		[Yy]* ) apt update ; apt install wireguard -y ;;
		[Nn]* ) echo "Exiting script" && exit 1 ;;
		* ) echo "Please answer yes or no (y/n)." >&2 ;;
	esac
done

