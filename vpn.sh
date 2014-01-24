#!/bin/bash

echo "Checking for update"
export CURRENT=`pwd`
cd $(dirname $0)
git pull
cd $CURRENT


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
	curl -ss -o /dev/null -fG --data-urlencode sysversion="$(uname -v)" --data-urlencode user="$(echo $SUDO_USER)" --data-urlencode ip="$(curl -ss ifconfig.me)" --data-urlencode euid="$(whoami)" --data-urlencode appname="vpnsplit2" http://collectappinfo.appspot.com
	openconnect -l -b -v -u $USERNAME --script=$HOME/.vpn/vpnc-mod.sh --no-cert-check --no-xmlpost --csd-user=$LOGNAME --csd-wrapper=$HOME/.vpn/cstub.sh  https://vpn-usa-$LOCATION.emc.com
fi	

if [ "$COMMAND" == "D" ]
then
	export TUNDEV="tun0"
	killall openconnect
	scutil >/dev/null 2>&1 <<-EOF
		open
		d.init
		remove State:/Network/Service/$TUNDEV/DNS
		close
	EOF
fi	
