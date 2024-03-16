## Wi-Fi ##

:: PROBLEM ::

$ sudo ifconfig wlan0 up
SIOCSIFFLAGS: Operation not possible due to RF-kill

$ sudo rfkill list
0: phy0: Wireless LAN
        Soft blocked: yes   ; <- note
        Hard blocked: no
1: hci0: Bluetooth
        Soft blocked: no
        Hard blocked: no


:: SOLUTION ::

$ sudo rfkill unblock wifi

reboot

$ sudo rfkill list
0: phy0: Wireless LAN
        Soft blocked: no    ; <- note
        Hard blocked: no
1: hci0: Bluetooth
        Soft blocked: no
        Hard blocked: no

$ sudo lshw -class network
[...]
68.1.3 link=yes maxpower=2mA multicast=yes port=MII speed=100Mbit/s
  *-network
       description: Wireless interface
       physical id: 2
       logical name: wlan0
       serial: b8:27:eb:ab:f1:e2
       capabilities: ethernet physical wireless
       configuration: broadcast=yes driver=brcmfmac driverversion=7.45.98.94 firmware=01-3b33decd multicast=yes wireless=IEEE 802.11


:: REFERENCES ::

[1]  https://askubuntu.com/a/62167/657351

==========================================================================

