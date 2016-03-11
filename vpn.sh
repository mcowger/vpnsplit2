



#!/bin/bash

# echo "Checking for update"
#
# if test `find ~/.vpn/.lastupdate.vpnsplit2 -mmin +10080`
# then
# 	echo "Update Possibly Needed...Checking..."
# 	export CURRENT=`pwd`
# 	cd $(dirname $0)
# 	git pull
# 	cd $CURRENT
# 	touch ~/.vpn/.lastupdate.vpnsplit2
# else
# 	echo "No Update Check Needed"
# fi



if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root or sudo " 1>&2
   exit 1
fi


export COMMAND=$1
export USERNAME=$2
export LOCATION=$3
export DIR=`dirname $0`

if [ -z "$COMMAND" ]
then
	echo "COMMAND not specified - (C)onnect or (D)isconnect"
	exit 1
fi



if [ -z "$LOCATION" ]
then
	export LOCATION="west"
fi

if [ "$COMMAND" == "C" ]
then
	if [ -z "$USERNAME" ]
	then
		echo "USERNAME not specified"
		exit 1
	fi

	echo "Checking for openconnect binary..."
	if [ ! -e /usr/local/bin/openconnect ]
	then
		echo "openconnect binary not found, install it with homebrew (http://brew.sh)"
		exit 1
	fi


	echo "Checking for cstub binary..."
	if [ ! -e /opt/cisco/hostscan/bin/cstub ]
	then
		echo "cstub binary not found, get a full copy of the anyconnect installer and add the 'Posture' component..."
		exit 1
	fi

	#echo "Updating Stats"
	#curl -ss -o /dev/null -fG --data-urlencode sysversion="$(uname -v)" --data-urlencode user="$(echo $SUDO_USER)" --data-urlencode ip="$(curl -ss icanhazip.com)" --data-urlencode euid="$USERNAME)" --data-urlencode appname="vpnsplit2" http://collectappinfo.appspot.com &
	echo "Running openconnect"
	DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
	openconnect -u $USERNAME --background --timestamp --no-cert-check  vpn-usa-$LOCATION.emc.com --csd-wrapper $DIR/csdwrapper.sh --script=$DIR/vpnc-script
	echo "Checking connection functionality"
	sleep 1
	ping -c 4 -i 1 -Q -t 1 -o 10.5.132.1
	export RESULT=$?
	if [ $RESULT == 0 ]
	then
		echo ""
		echo "YOU ARE CONNECTED"
	else
		echo ""
		echo "CONNECTION FAILED, CAN'T PING THROUGH TUNNEL.  RESULT:"
		echo $RESULT
	fi
	exit 0
fi

if [ "$COMMAND" == "D" ]
then
	export TUNDEV=`cat /tmp/tundev`
	if [ -z "$TUNDEV" ]
	then
		echo "TUNDEV not found: DNS will likely be broken"
		echo "Trying tun0 anyways"
		export TUNDEV="tun0"
	fi
	killall openconnect
	scutil >/dev/null 2>&1 <<-EOF
		open
		remove State:/Network/Service/$TUNDEV/IPv4
		remove State:/Network/Service/$TUNDEV/DNS
		close
	EOF
	echo "Briefly bouncing en0/en1 to clear cached DNS"
	sudo ifconfig en0 down && sudo ifconfig en0 up
	sudo ifconfig en1 down && sudo ifconfig en1 up
	exit 0
fi

echo "Command not properly specified - (C) or (D).  Try again"
exit 1









