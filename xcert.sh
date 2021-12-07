#!/bin/bash
echo start
sleep 0.5
source /var/lib/premium-script/ipvps.conf
domain=$IP
systemctl stop xray
systemctl stop xray@none
systemctl stop xray@vless
systemctl stop xray@vnone
/root/.acme.sh/acme.sh --issue -d $domain --standalone -k ec-256
~/.acme.sh/acme.sh --installcert -d $domain --fullchainpath /etc/xray/xray.crt --keypath /etc/xray/xray.key --ecc
systemctl start xray
systemctl start xray@none
systemctl start xray@vless
systemctl start xray@vnone
echo Done
sleep 0.5
clear 
neofetch