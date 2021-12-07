#!/bin/bash
red='\e[1;31m'
green='\e[0;32m'
NC='\e[0m'
MYIP=$(wget -qO- ipinfo.io/ip);
IZIN=$( curl https://raw.githubusercontent.com/faiz007t/premium/main/iptext.sh | grep $MYIP )
if [ $MYIP = $IZIN ]; then
clear
echo -e "${green} Please Wait, Proses...${NC}"
sleep 5
else
echo "User premium Only ,Sila Contact Admin Bot😘"
exit 0
fi
clear
domain=$(cat /etc/v2ray/domain)
tls="$(cat ~/log-install.txt | grep -w "XRAY VMESS TCP" | cut -d: -f2|sed 's/ //g')"
none="$(cat ~/log-install.txt | grep -w "XRAY VMESS NONE TCP" | cut -d: -f2|sed 's/ //g')"
mkcp="$(cat ~/log-install.txt | grep -w "XRAY VMESS KCP" | cut -d: -f2|sed 's/ //g')"
until [[ $user =~ ^[a-zA-Z0-9_]+$ && ${CLIENT_EXISTS} == '0' ]]; do
		read -rp "User: " -e user
		CLIENT_EXISTS=$(grep -w $user /etc/xray/vmesstls.json | wc -l)

		if [[ ${CLIENT_EXISTS} == '1' ]]; then
			echo ""
			echo "A client with the specified name was already created, please choose another name."
			exit 1
		fi
	done
uuid=$(cat /proc/sys/kernel/random/uuid)
read -p "Expired (days): " masaaktif
exp=`date -d "$masaaktif days" +"%Y-%m-%d"`
sed -i '/#tls$/a\### '"$user $exp"'\
},{"id": "'""$uuid""'","alterId": '"2"',"email": "'""$user""'"' /etc/xray/vmesstls.json
sed -i '/#none$/a\### '"$user $exp"'\
},{"id": "'""$uuid""'","alterId": '"64"',"email": "'""$user""'"' /etc/xray/vmessnone.json
sed -i '/#mkcp$/a\### '"$user $exp"'\
},{"id": "'""$uuid""'","alterId": '"2"',"email": "'""$user""'"' /etc/xray/mkcp.json
cat > /etc/xray/$user-tls.json << EOF
      {
      "v": "2",
      "ps": "${user}",
      "add": "${domain}",
      "port": "${tls}",
      "id": "${uuid}",
      "aid": "2",
      "net": "tcp",
      "path": "/xray",
      "type": "none",
      "host": "",
      "tls": "tls"
}
EOF
cat > /etc/xray/$user-none.json << EOF
      {
      "v": "2",
      "ps": "${user}",
      "add": "${domain}",
      "port": "${none}",
      "id": "${uuid}",
      "aid": "2",
      "net": "tcp",
      "path": "/xray",
      "type": "none",
      "host": "",
      "tls": "none"
}
EOF
cat > /etc/xray/$user-mkcp.json << EOF
      {
      "v": "2",
      "ps": "${user}",
      "add": "${domain}",
      "port": "${mkcp}",
      "id": "${uuid}",
      "aid": "64",
      "net": "kcp",
      "path": "/xray",
      "type": "dtls",
      "host": "",
      "tls": "none"
}
EOF
vmess_base641=$( base64 -w 0 <<< $vmess_json1)
vmess_base642=$( base64 -w 0 <<< $vmess_json2)
vmess_base643=$( base64 -w 0 <<< $vmess_json3)
vmesslink1="vmess://$(base64 -w 0 /etc/xray/$user-tls.json)"
vmesslink2="vmess://$(base64 -w 0 /etc/xray/$user-none.json)"
vmesslink3="vmess://$(base64 -w 0 /etc/xray/$user-mkcp.json)"
systemctl restart xray@vmessnone
systemctl restart xray@mkcp
systemctl restart xray@vmesstls
systemctl restart xray
service cron restart
clear
echo -e ""
echo -e "================================="
echo -e "            XRAY VMESS          " 
echo -e "================================="
echo -e "Remarks        : ${user}"
echo -e "Domain         : ${domain}"
echo -e "port TCP       : ${tls}"
echo -e "port none TCP  : ${none}"
echo -e "port KCP       : ${mkcp}"
echo -e "id             : ${uuid}"
echo -e "alterId        : 2"
echo -e "Security       : auto"
echo -e "network        : TCP"
echo -e "path           : /xray"
echo -e "================================="
echo -e "Link TCP       : ${vmesslink1}"
echo -e "================================="
echo -e "Link None TCP  : ${vmesslink2}"
echo -e "================================="
echo -e "Link KCP       : ${vmesslink3}"
echo -e "================================="
echo -e "Expired On     : $exp"
