#!/bin/bash
direct="$(cat ~/log-install.txt | grep -w "XRAY VLESS XTLS" | cut -d: -f2|sed 's/ //g')"
direct="$(cat ~/log-install.txt | grep -w "XRAY VLESS SPLICE" | cut -d: -f2|sed 's/ //g')"
direct="$(cat ~/log-install.txt | grep -w "XRAY VLESS WS XTLS" | cut -d: -f2|sed 's/ //g')"
echo -e "      Change Port $direct"
read -p "New Port XRAY XTLS,XRAY VLESS WS XTLS and XRAY VLESS SPLICE: " direct1
if [ -z $direct1 ]; then
echo "Please Input Port"
exit 0
fi
cek=$(netstat -nutlp | grep -w $direct1)
if [[ -z $cek ]]; then
sed -i "s/$direct/$direct1/g" /etc/xray/vlessxtls.json
sed -i "s/$direct/$direct1/g" /etc/xray/vlesslice.json
sed -i "s/$direct/$direct1/g" /etc/xray/vlessws.json
sed -i "s/   - XRAY VLESS XTLS         : $direct/   - XRAY VLESS XTLS     : $direct1/g" /root/log-install.txt
sed -i "s/   - XRAY VLESS SPLICE       : $direct/   - XRAY VLESS SPLICE     : $direct1/g" /root/log-install.txt
sed -i "s/   - XRAY VLESS WS XTLS      : $direct/   - XRAY VLESS WS XTLS     : $direct1/g" /root/log-install.txt
iptables -D INPUT -m state --state NEW -m tcp -p tcp --dport $direct -j ACCEPT
iptables -D INPUT -m state --state NEW -m udp -p udp --dport $direct -j ACCEPT
iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport $direct1 -j ACCEPT
iptables -I INPUT -m state --state NEW -m udp -p udp --dport $direct1 -j ACCEPT
iptables-save > /etc/iptables.up.rules
iptables-restore -t < /etc/iptables.up.rules
netfilter-persistent save > /dev/null
netfilter-persistent reload > /dev/null
systemctl restart xray > /dev/null
systemctl stop xray@vlessxtls > /dev/null
systemctl enable xray@vlessxtls > /dev/null
systemctl start xray@vlessxtls > /dev/null
systemctl stop xray@vlesslice > /dev/null
systemctl enable xray@vlesslice > /dev/null
systemctl start xray@vlesslice > /dev/null
systemctl stop xray@vlessws > /dev/null
systemctl enable xray@vlessws > /dev/null
systemctl start xray@vlessws > /dev/null

echo -e "\e[032;1mPort $direct1 modified successfully\e[0m"
else
echo "Port $direct1 is used"
fi
