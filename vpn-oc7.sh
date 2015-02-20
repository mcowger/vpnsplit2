#!/bin/bash

echo "Checking for update"

if test `find ~/.vpn/.lastupdate.vpnsplit2 -mmin +10080`
then
	echo "Update Possibly Needed...Checking..."
	export CURRENT=`pwd`
	cd $(dirname $0)
	git pull
	cd $CURRENT
	touch ~/.vpn/.lastupdate.vpnsplit2
else
	echo "No Update Check Needed"
fi



if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root or sudo " 1>&2
   exit 1
fi


export COMMAND=$1
export USERNAME=$2
export LOCATION=$3
export PIN=$4
export TOKEN=$5
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
	if [ -z "$TOKEN" ]
	then
		echo "Token not specified"
		exit 1
	fi
	if [ -z "$PIN" ]
	then
		echo "PIN not available"
		exit 1
	fi
	echo "Loading kext"
	kextload /Library/Extensions/tun.kext
	echo "Updating Stats"
	curl -ss -o /dev/null -fG --data-urlencode sysversion="$(uname -v)" --data-urlencode user="$(echo $SUDO_USER)" --data-urlencode ip="$(curl -ss icanhazip.com)" --data-urlencode euid="$USERNAME)" --data-urlencode appname="vpnsplit2" http://collectappinfo.appspot.com &
	echo "Running openconnect"
	export PASSCODE=$PIN$TOKEN
	echo $PASSCODE | openconnect -v -l -b --non-inter --disable-ipv6 --passwd-on-stdin -u $USERNAME --script=$HOME/.vpn/vpnc-mod.sh --no-cert-check --no-xmlpost --csd-user=$LOGNAME --csd-wrapper=$HOME/.vpn/cstub.sh  https://vpn-usa-$LOCATION.emc.com
	ping -c 4 -i .2 -Q -t 1 -o 10.5.132.1
fi

if [ "$COMMAND" == "D" ]
then
	export TUNDEV=`cat /tmp/tundev`
	if [ -z "$TUNDEV" ]
	then
		echo "TUNDEV not found: DNS will likely be broken"
		exit 1
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
fi
