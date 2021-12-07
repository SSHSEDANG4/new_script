#!/bin/bash
red='\e[1;31m'
green='\e[0;32m'
NC='\e[0m'
MYIP=$(wget -qO- ifconfig.me/ip);
echo "Checking VPS"

clear
tls="$(cat ~/log-install.txt | grep -w "XRAY VMESS TCP" | cut -d: -f2|sed 's/ //g')"
none="$(cat ~/log-install.txt | grep -w "XRAY VMESS NONE TCP" | cut -d: -f2|sed 's/ //g')"
mkcp="$(cat ~/log-install.txt | grep -w "XRAY VMESS KCP" | cut -d: -f2|sed 's/ //g')"
echo -e "======================================"
echo -e "      Change Port XRAY Vmess"
echo -e ""
echo -e "     [1]  Change Port XRAY Vmess TCP $tls"
echo -e "     [2]  Change Port XRAY Vmess None TCP $none"
echo -e "     [3]  Change Port XRAY Vmess KCP $mkcp"
echo -e "     [x]  Exit"
echo -e "======================================"
echo -e ""
read -p "     Select From Options [1-3 or x] :  " prot
echo -e ""
case $prot in
1)
read -p "New Port XRAY Vmess TCP: " tls1
if [ -z $tls1 ]; then
echo "Please Input Port"
exit 0
fi
cek=$(netstat -nutlp | grep -w $tls1)
if [[ -z $cek ]]; then
sed -i "s/$tls/$tls1/g" /etc/xray/vmesstls.json
sed -i "s/   - XRAY VMESS TCP          : $tls/   - XRAY VMESS TCP          : $tls1/g" /root/log-install.txt
iptables -D INPUT -m state --state NEW -m tcp -p tcp --dport $tls -j ACCEPT
iptables -D INPUT -m state --state NEW -m udp -p udp --dport $tls -j ACCEPT
iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport $tls1 -j ACCEPT
iptables -I INPUT -m state --state NEW -m udp -p udp --dport $tls1 -j ACCEPT
iptables-save > /etc/iptables.up.rules
iptables-restore -t < /etc/iptables.up.rules
netfilter-persistent save > /dev/null
netfilter-persistent reload > /dev/null
systemctl restart xray@vmesstls > /dev/null
echo -e "\e[032;1mPort $tls1 modified successfully\e[0m"
else
echo "Port $tls1 is used"
fi
;;
2)
echo "Input Only 2 Character (eg : 69)"
read -p "New Port XRAY Vmess None TCP: " none1
if [ -z $none1 ]; then
echo "Please Input Port"
exit 0
fi
cek=$(netstat -nutlp | grep -w $none1)
if [[ -z $cek ]]; then
sed -i "s/$none/$none1/g" /etc/xray/vmessnone.json
sed -i "s/   - XRAY VMESS NONE TCP     : $none/   - XRAY VMESS NONE TCP     : $none1/g" /root/log-install.txt
iptables -D INPUT -m state --state NEW -m tcp -p tcp --dport $none -j ACCEPT
iptables -D INPUT -m state --state NEW -m udp -p udp --dport $none -j ACCEPT
iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport $none1 -j ACCEPT
iptables -I INPUT -m state --state NEW -m udp -p udp --dport $none1 -j ACCEPT
iptables-save > /etc/iptables.up.rules
iptables-restore -t < /etc/iptables.up.rules
netfilter-persistent save > /dev/null
netfilter-persistent reload > /dev/null
systemctl restart xray@vmessnone > /dev/null
echo -e "\e[032;1mPort $none1 modified successfully\e[0m"
else
echo "Port $none1 is used"
fi
;;
3)
read -p "New Port XRAY Vmess KCP: " mkcp1
if [ -z $mkcp1 ]; then
echo "Please Input Port"
exit 0
fi
cek=$(netstat -nutlp | grep -w $mkcp1)
if [[ -z $cek ]]; then
sed -i "s/$mkcp/$mkcp1/g" /etc/xray/mkcp.json
sed -i "s/   - XRAY VMESS KCP          : $mkcp/   - XRAY VMESS KCP          : $mkcp1/g" /root/log-install.txt
iptables -D INPUT -m state --state NEW -m tcp -p tcp --dport $mkcp -j ACCEPT
iptables -D INPUT -m state --state NEW -m udp -p udp --dport $mkcp -j ACCEPT
iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport $mkcp1 -j ACCEPT
iptables -I INPUT -m state --state NEW -m udp -p udp --dport $mkcp1 -j ACCEPT
iptables-save > /etc/iptables.up.rules
iptables-restore -t < /etc/iptables.up.rules
netfilter-persistent save > /dev/null
netfilter-persistent reload > /dev/null
systemctl restart xray@mkcp.service > /dev/null
echo -e "\e[032;1mPort $mkcp1 modified successfully\e[0m"
else
echo "Port $mkcp1 is used"
fi
;;
x)
exit
menu
;;
*)
echo "Please enter an correct number"
;;
esac
