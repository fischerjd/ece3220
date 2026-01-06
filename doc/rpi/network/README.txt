File: README.txt
Date: 2026-Jan-06
© 2026 James D. Fischer
---------------------------------------------------------------------------

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
  *-interface:0
       description: Wireless interface
       product: 43430
       vendor: Broadcom
       physical id: 1
       bus info: mmc@1:0001:1
       logical name: mmc1:0001:1
       logical name: wlan0
       serial: b8:27:eb:c1:3f:4e
       capabilities: ethernet physical wireless
       configuration: broadcast=yes driver=brcmfmac driverversion=7.45.98 firmware=01-8e14b897 multicast=yes wireless=IEEE 802.11

:: REFERENCES ::

[1]  https://askubuntu.com/a/62167/657351

==========================================================================

