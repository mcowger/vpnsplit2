vpnsplit2
=========


Install Instructions:
---------
0. Install AnyConnect 3.1
1. Install the most recent XCode for your platform (5.01 for Mavericks).  Include the command line tools.
2. Install the [Mac OS X TUN/TAP driver](http://tuntaposx.sourceforge.net/)
3. Install [homebrew](http://mxcl.github.com/homebrew/)
4. Use homebrew to install openconnect

    >brew update
    > 
    >brew install openconnect


5. Get the latest wrapper scripts from my github (do this from your home directory)

    > git clone http://github.com/mcowger/vpnsplit2.git .vpn
    
6. Everything is installed!

Usage
----------
To connect to the VPN:
>   sudo ./vpn.sh C NT-USERNAME [south|_west_|east]

'C' stands for connect, your username should be obvious, and the optional parameter specifies which VPN server to connect to (defaults to west).

You'll get some output that looks like the following:

````
<HOMEDIR>/.vpn/cstub.sh /tmp/csdrB5b6c -ticket "07758A474315618622432261" -stub "0" -group "" -certhash "9CE3B7DC697B5FDAA01538E4ECA4B741:" -url "[redacted]" -langselen
URL:          "[redacted]"
TICKET:       "07758A474315618622432261"
STUB:         "0"
GROUP:
CERTHASH:     "9CE3B7DC697B5FDAA01538E4ECA4B741:"
LANGSELEN:
Executing /opt/cisco/hostscan/bin/cstub -url "[redacted]/CACHE/sdesktop/install/result.htm" -ticket "07758A474315618622432261" -stub "0" -certhash "9CE3B7DC697B5FDAA01538E4ECA4B741:"
<BANNER>
Please enter your username and password.
PASSCODE:
````
Enter your passcode at the prompt.  Once you do, you'll get:
````
Connect Banner:
| *******************************************
| !!! This is a restricted area !!!
| Access only authorized for EMC Approved Personnel.
| If you are not authorized by EMC,
| PLEASE DISCONNECT NOW.
|
| This group permits Local Lan Access.
| ********************************************
| [redacted]
| ********************************************
|

add host 111.22.333.44: gateway 192.168.X.1
[snip more]
````
And the script will exit and you are connected.  All standard resources are available via the VPN, but the tunnel is now a split include (meaning only certain address spaces are routed through the VPN, and all others around it).  Split-DNS is also enabled, meaning that the DNS server pushed by the VPN server is used only for the pushed domains, and all lookups happen against your standard DNS server.


To disconnect
>sudo ./vpn.sh D NT-USERNAME

The openconnect process will be killed and all your routes and DNS are put back.
