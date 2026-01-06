File: README.txt
Date: 2026-Jan-06
© 2026 James D. Fischer
---------------------------------------------------------------------------

Use program nmcli(1) to create the NetworkManager *.nmconnection
configuration files that are stored in this folder.

---------------------------------------------------------------------------
:: EXAMPLE ::

$ WIFI_SSID='XYZ'
$ WIFI_PASSPHRASE='Secret_Wi-Fi_Passphrase'

# Use wpa_passphrase(8) to convert the human-readable passphrase string
# into a WPA PSK hash value. Use sed(1) to extract the WPA PSK hash value
# from the wpa_passphrase output.

$ wpa_psk="$(wpa_passphrase "$WIFI_SSID" "$WIFI_PASSPHRASE" \
	| sed -n -e '/[[:blank:]]psk=/ {s/[[:blank:]]*psk=//g;p}')"

# Use nmcli(1) in offline mode (without the NetworkManager daemon) to
# create the nmconnection file:

$ nmcli --offline \
    connection add \
    con-name "$WIFI_SSID" \
    connection.type 802-11-wireless \
    connection.interface-name wlan0 \
    connection.autoconnect-priority 5 \
    wifi.mode infrastructure \
    wifi.powersave 2 \
    wifi.ssid ENGR \
    wifi-sec.key-mgmt wpa-psk \
    wifi-sec.psk "${wpa_psk}" \
    > example.nmconnection

