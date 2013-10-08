export USERNAME=$1
export DIR=`dirname $0`

sudo openconnect -u $USERNAME --script=$DIR/vpnc-mod.sh --quiet --no-cert-check --no-xmlpost --csd-user=$LOGNAME --csd-wrapper=$DIR/cstub.sh  https://vpn-usa-west.emc.com
