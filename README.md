vpnsplit2
=========


Install Instructions:
---------

1. Install the most recent XCode for your platform by running `xcode-select --install`.  They may already be installed, in which case continue with the next stop.  If you can't figure this out, ask for help from someone, it only gets harder from here.
2. Install [homebrew](http://mxcl.github.com/homebrew/) with this command: `ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"`
4. Use homebrew to install openconnect: `brew update && brew install openconnect`
5. Get the latest wrapper scripts from my github: `cd ~ && git clone http://github.com/mcowger/vpnsplit2.git .vpn`
6. Everything is installed!

Usage
----------
To connect to the VPN:
>   sudo ~/.vpn/vpn-oc7.sh C NT-USERNAME [south|_west_|east] [PIN|NONE] [TOKEN CODE]

* 'C' stands for connect, your username should be obvious.  
* Select 'south', 'west', or 'east' to choose which endpoint you connect to.  
* Next, if you use a hard token, enter your PIN...*if you use a soft token, just enter 'NONE' here*.  
* The last field is for whatever value your token is displaying (either the 6 digits on the hard token, or the 8 from the soft token after you enter your PIN there).

You'll get some output that looks like the following:

```
Checking for update
No Update Check Needed
Checking for cstub binary...
cstub binary not found, downloading...
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0
100  354k  100  354k    0     0   277k      0  0:00:01  0:00:01 --:--:--  277k
binary downloaded and installed in ~/.vpn
Updating Stats
Running openconnect
Runnning cstub binary...
-url "https://scl02-01i11-vn01.emc.com/CACHE/sdesktop/install/result.htm" -ticket "5F9D63702BC7B1B366BB1322" -stub "0" -certhash "3D1F7128B9A4E8CD063D8FCB23FA3401:"
cstub complete
This Virtual Private Network is intended for
authorized EMC employees and contractors.
Unauthorized use is prohibited by law and may be
subject to civil and/or criminal penalties. This system
may be logged or monitored without further notice
and resulting logs may be used as evidence in court.
Please enter your username and password.
Checking connection functionality
PING 10.5.132.1 (10.5.132.1): 56 data bytes
64 bytes from 10.5.132.1: icmp_seq=0 ttl=244 time=76.067 ms

--- 10.5.132.1 ping statistics ---
1 packets transmitted, 1 packets received, 0.0% packet loss
round-trip min/avg/max/stddev = 76.067/76.067/76.067/0.000 ms

YOU ARE CONNECTED
```


And the script will exit and you are connected, per the note above.  All standard resources are available via the VPN, but the tunnel is now a split include (meaning only certain address spaces are routed through the VPN, and all others around it).  Split-DNS is also enabled, meaning that the DNS server pushed by the VPN server is used only for the pushed domains, and all lookups happen against your standard DNS server.


To disconnect
>sudo ./vpn-oc7.sh D 

The openconnect process will be killed and all your routes and DNS are put back.
