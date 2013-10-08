export USERNAME=cowgem

sudo openconnect -u $USERNAME --script=$HOME/.vpn/vpnc-mod.sh --quiet --no-cert-check --no-xmlpost --csd-user=$LOGNAME --csd-wrapper=$HOME/.vpn/cstub.sh  https://vpn-usa-west.emc.com