#!/bin/bash
red='\e[1;31m'
green='\e[0;32m'
NC='\e[0m'
MYIP=$(wget -qO- ipinfo.io/ip);
echo "Checking VPS"
clear
uuid=$(cat /etc/trojan-go/uuid.txt)
source /var/lib/premium-script/ipvps.conf
if [[ "$IP" = "" ]]; then
domain=$(cat /etc/v2ray/domain)
else
domain=$IP
fi
trojango="$(cat ~/log-install.txt | grep -i Trojan GO | cut -d: -f2|sed 's/ //g')"
trojango="$(cat ~/log-install.txt | grep -w "Trojan GO" | cut -d: -f2|sed 's/ //g')"
until [[ $user =~ ^[a-zA-Z0-9_]+$ && ${user_EXISTS} == '0' ]]; do
                echo "Name : Create Trojan GO Account"
		echo "=================================="
		read -rp "Password : " -e user
		user_EXISTS=$(grep -w $user /etc/trojan-go/akun.conf | wc -l)

		if [[ ${user_EXISTS} == '1' ]]; then
			echo ""
			echo "A client with the specified name was already created, please choose another name."
			exit 1
		fi
	done
read -p "Expired (days) : " masaaktif
sed -i '/"'""$uuid""'"$/a\,"'""$user""'"' /etc/trojan-go/config.json
exp=`date -d "$masaaktif days" +"%Y-%m-%d"`
echo -e "### $user $exp" >> /etc/trojan-go/akun.conf
systemctl restart trojan-go.service
trojangolink="trojan-go://${uuid}@${domain}:${trojango}/?sni=${domain}&type=ws&host=${domain}&path=/brody&encryption=none#${user}"
clear
echo -e "Name : Trojan-GO" 
echo -e "===================================" | lolcat
echo -e "Remarks    = ${user}"
echo -e "IP / Host  = ${domain}"
echo -e "Port       = ${trojango}"
echo -e "Path       = /brody"
echo -e "Expired    = $exp"
echo -e "===================================" | lolcat
echo -e "Link TROJAN-GO : ${trojangolink}"
echo -e "===================================" | lolcat
