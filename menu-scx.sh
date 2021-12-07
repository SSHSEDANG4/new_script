#!/bin/bash
source /var/lib/premium-script/ipvps.conf
if [[ "$IP" = "" ]]; then
domain=$(cat /etc/v2ray/domain)
else
domain=$IP
fi

# // Vless
vless1="$( cat /etc/xray/vless-ws.json | grep -w port | awk '{print $2}' | sed 's/,//g' )"
until [[ $user =~ ^[a-zA-Z0-9_]+$ && ${CLIENT_EXISTS} == '0' ]]; do
		read -rp "User: " -e user
		CLIENT_EXISTS=$(grep -w $user /etc/xray/vless-ws.json | wc -l)

		if [[ ${CLIENT_EXISTS} == '1' ]]; then
			echo ""
			echo "A client with the specified name was already created, please choose another name."
			exit 1
		fi
	done

uuid=$(cat /proc/sys/kernel/random/uuid)
read -p "Expired (days): " masaaktif
exp=`date -d "$masaaktif days" +"%Y-%m-%d"`

# // Input To Server
sed -i '/#XRay$/a\### '"$user $exp"'\
},{"id": "'""$uuid""'","flow": "xtls-rprx-direct","email": "'""$user""'"' /etc/xray/vless-ws.json

vless_direct="vless://${uuid}@${domain}:${vless1}?security=xtls&encryption=none&headerType=none&type=tcp&flow=xtls-rprx-direct&sni=bug#$user"
vless_ws="vless://${uuid}@${domain}:${vless1}?security=tls&encryption=none&headerType=none&type=tcp&flow=xtls-rprx-direct&sni=bug#$user"
vless_ws1="vless://${uuid}@${domain}:${vless1}?security=tls&encryption=none&headerType=ws&type=tcp&flow=xtls-rprx-direct&sni=bug#$user"
vlesslink1="vless://${uuid}@${domain}:${vless1}$tls?path=/xray&security=tls&encryption=none&type=ws#${user}"
vlesslink2="vless://${uuid}@${domain}:${vless1}$none?path=/xray&encryption=none&type=ws#${user}"
# // Restarting Service
systemctl stop xray@vless-direct
systemctl stop xray@vless-ws
systemctl disable xray@vless-direct
systemctl disable xray@vless-ws
systemctl enable xray@vless-direct
systemctl enable xray@vless-ws
systemctl start xray@vless-direct
systemctl start xray@vless-ws
systemctl restart xray@vless-direct
systemctl restart xray@vless-ws

clear
echo -e ""
echo -e "==========-XRAYS/VLESS-=========="
echo -e "Remarks        : ${user}"
echo -e "Domain         : ${domain}"
echo -e "Port Direct    : $vless1"
echo -e "Port Splice    : $vless1"
echo -e "id             : ${uuid}"
echo -e "path           : /darknet"
echo -e "================================="
echo -e "Link Direct    : ${vless_direct}"
echo -e "================================="
echo -e "Link WS        : ${vless_ws}"
echo -e "================================="
echo -e "link All       : ${vless_ws1}"
echo -e "================================="
echo -e "link All       : ${vlesslink1}"
echo -e "================================="
echo -e "link All       : ${vless_vless2}"
echo -e "Expired On     : $exp"
