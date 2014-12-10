#!/bin/bash



cidr2mask() {
  local i mask=""
  local full_octets=$(($1/8))
  local partial_octet=$(($1%8))

  for ((i=0;i<4;i+=1)); do
    if [ $i -lt $full_octets ]; then
      mask+=255
    elif [ $i -eq $full_octets ]; then
      mask+=$((256 - 2**(8-$partial_octet)))
    else
      mask+=0
    fi  
    test $i -lt 3 && mask+=.
  done

  echo $mask
}

mask2cidr() {
    nbits=0
    IFS=.
    for dec in $1 ; do
        case $dec in
            255) let nbits+=8;;
            254) let nbits+=7;;
            252) let nbits+=6;;
            248) let nbits+=5;;
            240) let nbits+=4;;
            224) let nbits+=3;;
            192) let nbits+=2;;
            128) let nbits+=1;;
            0);;
            *) echo "Error: $dec is not recognised"; exit 1
        esac
    done
    echo "$nbits"
}



#Add one IP to the list of split tunnel
add_network ()
{
        export CISCO_SPLIT_INC_${CISCO_SPLIT_INC}_ADDR=$1
		export MASK=$(cidr2mask $2)
        export CISCO_SPLIT_INC_${CISCO_SPLIT_INC}_MASK=$MASK
        export CISCO_SPLIT_INC_${CISCO_SPLIT_INC}_MASKLEN=$2
        export CISCO_SPLIT_INC=$(($CISCO_SPLIT_INC + 1))
}

# Initialize empty split tunnel list
export CISCO_SPLIT_INC=0

# Delete DNS info provided by VPN server to use internet DNS
# Comment following line to use DNS beyond VPN tunnel
#unset INTERNAL_IP4_DNS
#echo INTERNAL_IP4_DNS > /tmp/me

# List of IPs beyond VPN tunnel
add_network 10.0.0.0 8
add_network 74.85.160.0 19
add_network 152.62.0.0 16
add_network 128.221.0.0 16
add_network 128.222.0.0 16
add_network 137.69.0.0 16
add_network 168.159.0.0 16 
add_network 208.80.57.0 24
add_network 208.80.56.11 32
add_network 208.80.59.87 24
add_network 72.15.252.44 32
add_network 204.14.232.0 21
add_network 24.147.105.75 32        
add_network 63.170.232.0 24

# Execute default script
. $HOME/.vpn/vpnc-script




# End of script
