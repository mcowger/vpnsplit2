# vpnsplit2

## Install Instructions:

0. Make sure you have the LATEST version of Anyconnect installed (currently 4.2), WITH the posture option!  You might need to google to find this :)
1. Install the most recent XCode for your platform by running `xcode-select --install`.  They may already be installed, in which case continue with the next stop.  If you can't figure this out, ask for help from someone, it only gets harder from here.
2. Install [homebrew](http://mxcl.github.com/homebrew/) with this command: `ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"`
4. Use homebrew to install openconnect: `brew update && brew install openconnect`
5. Get the latest wrapper scripts from my github: `cd ~ && git clone http://github.com/mcowger/vpnsplit2.git .vpn && cd .vpn &&  cd -`
6. Set write permissions to the script: `chmod +x ~/.vpn/vpn.sh`
7. You are good to go!

## Usage

#### To connect to the VPN

>   sudo ~/.vpn/vpn.sh C NT-USERNAME [VPN endpoint]

* `C` stands for connect
* Your VPN username
* Type the VPN server endpoint you want to connect to (e.g. `vpn-usa-west.mycompany.com`). Not needed if you have set the `VPNSERVER` environment variable.

You'll get some output that looks like the following:

```
Checking for openconnect binary...
Checking for cstub binary...
Running openconnect
<snip>
Runnning cstub binary...with CLI:
-url "https://scl02-01i11-vn01.emc.com/CACHE/sdesktop/install/result.htm" -ticket "0FEA06596BF0DAA068CEC7A3" -stub "0" -certhash "3D1F7128B9A4E8CD063D8FCB23FA3401:"
<snip>
cstub complete
<snip>
Please enter your username and password.
PASSCODE:
[2016-01-05 14:30:03] POST https://scl02-01i11-vn01.emc.com/+webvpn+/index.html
[2016-01-05 14:30:07] Got CONNECT response: HTTP/1.1 200 OK
[2016-01-05 14:30:07] CSTP connected. DPD 90, Keepalive 30
[2016-01-05 14:30:07] Connected utun1 as 10.13.38.90, using SSL
[2016-01-05 14:30:07] Continuing in background; pid 26621
Checking connection functionality
[2016-01-05 14:30:07] Established DTLS connection (using GnuTLS). Ciphersuite (DTLS0.9)-(RSA)-(AES-256-CBC)-(SHA1).
PING 10.5.132.1 (10.5.132.1): 56 data bytes
64 bytes from 10.5.132.1: icmp_seq=0 ttl=244 time=85.623 ms

--- 10.5.132.1 ping statistics ---
1 packets transmitted, 1 packets received, 0.0% packet loss
round-trip min/avg/max/stddev = 85.623/85.623/85.623/0.000 ms

YOU ARE CONNECTED

```


And the script will exit and you are connected, per the note above.  All standard resources are available via the VPN, but the tunnel is now a split include (meaning only certain address spaces are routed through the VPN, and all others around it).  Split-DNS is also enabled, meaning that the DNS server pushed by the VPN server is used only for the pushed domains, and all lookups happen against your standard DNS server.


#### To disconnect

> sudo ~/.vpn/vpn.sh D

The openconnect process will be killed and all your routes and DNS are put back.
