#!/bin/sh

echo "$0 $*"

shift

URL=
TICKET=
STUB=
GROUP=
CERTHASH=
LANGSELEN=

while [ "$1" ]; do
    if [ "$1" == "-ticket" ];   then shift; TICKET=$1; fi
    if [ "$1" == "-stub" ];     then shift; STUB=$1; fi
    if [ "$1" == "-group" ];    then shift; GROUPR=$1; fi
    if [ "$1" == "-certhash" ]; then shift; CERTHASH=$1; fi
    if [ "$1" == "-url" ];      then shift; URL=$1; fi
    if [ "$1" == "-langselen" ];then shift; LANGSELEN=$1; fi
    shift
done

echo "URL:          $URL"
echo "TICKET:       $TICKET"
echo "STUB:         $STUB"
echo "GROUP:        $GROUP"
echo "CERTHASH:     $CERTHASH"
echo "LANGSELEN:    $LANGSELEN"

ARGS="-url $URL -ticket $TICKET -stub $STUB"
if [ "$GROUP" ]; then ARGS="$ARGS -group $GROUP"; fi
ARGS="$ARGS -certhash $CERTHASH"
if [ "$LANGSELEN" ]; then ARGS="$ARGS -langsel $LANGSELEN"; fi

echo "Executing /opt/cisco/hostscan/bin/cstub $ARGS"
/opt/cisco/hostscan/bin/cstub $ARGS
#$HOME/.vpn/cstub $ARGS