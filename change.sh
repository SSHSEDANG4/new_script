#!/bin/bash
echo -e ""
echo -e "======================================"
echo -e ""
echo -e "   $blue [1]  Change Port Stunnel4"
echo -e "   $blue [2]  Change Port OpenVPN"
echo -e "   $blue [3]  Change Port Wireguard"
echo -e "   $blue [4]  Change Port Vmess"
echo -e "   $blue [5]  Change Port Vless"
echo -e "   $blue [6]  Change Port Trojan"
echo -e "   $blue [7]  Change Port Squid"
echo -e "   $blue [8]  Change Port SSTP"
echo -e "   $blue [9]  Change Port XRAY"
echo -e "   $blue [10] Change Port Trojan GO"
echo -e "   $blue [11]$NC $yell BACK TO MENU$NC"
echo -e "======================================"
echo -e ""
read -p "     Select From Options [1-10 or x] :  " port
echo -e ""
case $port in
1)
port-ssl
;;
2)
port-ovpn
;;
3)
port-wg
;;
4)
port-ws
;;
5)
port-vless
;;
6)
port-tr
;;
7)
port-squid
;;
8)
port-sstp
;;
9)
menu-xx
;;
10)
port-trgo
;;
11)
clear
menu
;;
*)
echo "Please enter an correct number"
;;
esac
