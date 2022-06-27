#!/bin/bash

wg_dir="/etc/wireguard"

#Define function to for yes/no/cancel prompts
yn() {
	

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

#Check if iptables is installed
while $(dpkg -s iptables &> /dev/null) ; [[ $? -ne 0 ]]; do
	read -p "iptables package is not installed. Do you wish to install it now? (y/n) " yn
	case $yn in
		[Yy]* ) apt update ; apt install iptables -y ;;
		[Nn]* ) echo "Exiting script" && exit 1 ;;
		* ) echo "Please answer yes or no (y/n)" >&2 ;;
	esac
done

#Check if keys haven't been generated under the same filename already
if [[ -f $wg_dir/privatekey && $wg_dir/publickey ]] ; then
#need to use function here i think	
fi
#Generate WG keys
$(cd $wg_dir && wg genkey | tee privatekey | wg pubkey > publickey) &> /dev/null
echo "Your private key is (do not share this!):"
cat $wg_dir/privatekey 
echo
echo "Your public key is (copy this to your peer/router!):"
cat $wg_dir/publickey

exit 0	
