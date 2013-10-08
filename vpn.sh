#!/bin/bash

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

if [ -z "$USERNAME" ]
then
	echo "USERNAME not specified"
	exit 1
fi

if [ -z "$LOCATION" ]
then
	export LOCATION="west"
fi

if [ "$COMMAND" == "C" ]
then
	sudo openconnect -l -b -u $USERNAME --script=$HOME/.vpn/vpnc-mod.sh --no-cert-check --no-xmlpost --csd-user=$LOGNAME --csd-wrapper=$HOME/.vpn/cstub.sh  https://vpn-usa-$LOCATION.emc.com
fi	

if [ "$COMMAND" == "D" ]
then
	sudo killall openconnect
fi	