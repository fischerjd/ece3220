File: README.txt
Date: 2026-Jan-17
© 2026 James D. Fischer
---------------------------------------------------------------------------

General Comment

Use program nmcli(1) to create the NetworkManager *.nmconnection configu-
ration files that reside in the system folder

    /etc/NetworkManager/system-connections/

---------------------------------------------------------------------------
:: EXAMPLE ::

$ WIFI_SSID='XYZ'
$ WIFI_PASSPHRASE='Secret_Wi-Fi_Passphrase'

# Use wpa_passphrase(8) to convert the human-readable passphrase string in
# variable WIFI_PASSPHRASE into a Wi-Fi protected access pre-shared key
# (WPA-PSK) hash value.
# [Note 1: Program wpa_passphrase prints multiple lines of text:
#   network={
#           ssid="XYZ"
#           #psk="Secret_Wi-Fi_Passphrase"
#           psk=0831d61b9e99af59f6716e6be044436620ab476acefe6cb021a69d7005725379
#   }
# The example command line below pipes wpa_passphrase's output through the
# stream editor program sed(1) which then filters out and prints only the
# WPA-PSK hash value. --end note]

$ WPA_PSK="$(wpa_passphrase "$WIFI_SSID" "$WIFI_PASSPHRASE" \
    | sed -n -E -e '/^[[:blank:]]*psk[[:blank:]]*=/ {s/^[[:blank:]]*psk[[:blank:]]*=[[:blank:]]*(.*)[[:blank:]]*$/\1/p;q}')"

$ echo "$WPA_PSK"
0831d61b9e99af59f6716e6be044436620ab476acefe6cb021a69d7005725379

---------------------------------------------------------------------------
# Use NetworkManager's command line interface app nmcli(1) in offline mode
# (i.e., don't engage the NetworkManager daemon) to create an nmconnection
# file named 'example.nmconnection' that contains the NetworkManager
# configuration settings for the Wi-Fi network.
# [Note 1: The connection setting 'wifi.powersave=2' disables powersave
# on the Wi-Fi radio. This setting tells the NetworkManager daemon it
# should not turn off the Wi-Fi radio to save power. --end note]

$ nmcli --offline \
    connection add \
    con-name "$WIFI_SSID" \
    connection.type 802-11-wireless \
    connection.interface-name wlan0 \
    connection.autoconnect-priority 5 \
    wifi.mode infrastructure \
    wifi.powersave 2 \
    wifi.ssid "$WIFI_SSID" \
    wifi-sec.key-mgmt wpa-psk \
    wifi-sec.psk "$WPA_PSK" \
    > example.nmconnection

---------------------------------------------------------------------------
$ cat example.nmconnection
[connection]
id=XYZ
uuid=faa74641-d6d0-40d4-a85b-f5fea180f9f8
type=wifi
autoconnect-priority=5
interface-name=wlan0

[wifi]
mode=infrastructure
powersave=2
ssid=XYZ

[wifi-security]
key-mgmt=wpa-psk
psk=0831d61b9e99af59f6716e6be044436620ab476acefe6cb021a69d7005725379

[ipv4]
method=auto

[ipv6]
addr-gen-mode=default
method=auto

[proxy]


---------------------------------------------------------------------------
# Install the nmconnection file into the system directory

$ sudo install --mode=0600 --owner=root --group=root \
    example.nmconnection \
    /etc/NetworkManager/system-connections/

---------------------------------------------------------------------------
# Restart the NetworkManager service

$ sudo systemctl restart NetworkManager

