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
	echo "Loading kext"
	kextload /Library/Extensions/tun.kext
	echo "Updating Stats"
	curl -ss -o /dev/null -fG --data-urlencode sysversion="$(uname -v)" --data-urlencode user="$(echo $SUDO_USER)" --data-urlencode ip="$(curl -ss icanhazip.com)" --data-urlencode euid="$USERNAME)" --data-urlencode appname="vpnsplit2" http://collectappinfo.appspot.com &
	echo "Running openconnect"
	openconnect -l -b -vvv   -u $USERNAME --script=$HOME/.vpn/vpnc-mod.sh --no-cert-check --no-xmlpost --csd-user=$LOGNAME --csd-wrapper=$HOME/.vpn/cstub.sh  https://vpn-usa-$LOCATION.emc.com
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
fi

if [ "$COMMAND" == "D" ]
then
    export TUNDEV=$(scutil --dns |grep if_index |grep tun |awk {'print $NF'} |tr -d '()')
    if [ -z "$TUNDEV" ]
    then
        echo "Could not dynamically discover TUNDEV; defaulting to utun0"
	    export TUNDEV="utun0"
    fi
	killall openconnect
	scutil >/dev/null 2>&1 <<-EOF
		open
		d.init
		remove State:/Network/Service/$TUNDEV/DNS
		close
	EOF
	echo "Briefly bouncing en0/en1 to clear cached DNS"
	sudo ifconfig en0 down && sudo ifconfig en0 up
	sudo ifconfig en1 down && sudo ifconfig en1 up
fi
