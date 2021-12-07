#!/bin/bash
clear
echo -e "════════════════════════════════════════════════════════════
=             Script Vps For Debian N Ubuntu   "
echo -e ""
echo -e "   __   __ ___  ___  ___   ___  _____ "
echo -e "   \ \ / /| _ \/ __|| _ ) / _ \|_   _|"
echo -e "    \ V / |  _/\__ \| _ \| (_) | | |  "
echo -e "     \_/  |_|  |___/|___/ \___/  |_|  "
echo -e ""
echo -e "\e[94m  .----------------------------------------------------.    "
echo -e "\e[94m  |              XRAY VLESS/Vmess MENU                 |    "
echo -e "\e[94m  '----------------------------------------------------'    "
echo -e "\e[0m                                                               "
echo -e "\e[1;31m* [1]\e[0m \e[1;32m:  Create XRAY Vmess\e[0m"
echo -e "\e[1;31m* [2]\e[0m \e[1;32m:  Create XRAY Vless\e[0m"
echo -e "\e[1;31m* [3]\e[0m \e[1;32m:  Create XRAY Vless XTLS\e[0m"
echo -e "\e[1;31m* [4]\e[0m \e[1;32m:  Deleting XRAY Vless XTLS\e[0m"
echo -e "\e[1;31m* [5]\e[0m \e[1;32m:  Deleting XRAY Vmess\e[0m"
echo -e "\e[1;31m* [6]\e[0m \e[1;32m:  Deleting XRAY Vless\e[0m"
echo -e "\e[1;31m* [7]\e[0m \e[1;32m:  Check XRAY Vmess\e[0m"
echo -e "\e[1;31m* [8]\e[0m \e[1;32m:  Check XRAY Vless\e[0m"
echo -e "\e[1;31m* [9]\e[0m \e[1;32m:  Check XRAY Vless XTLS\e[0m"
echo -e "\e[1;31m* [10]\e[0m \e[1;32m: Extending XRAY Vless XTLS\e[0m"
echo -e "\e[1;31m* [11]\e[0m \e[1;32m: Extending XRAY Vmess\e[0m"
echo -e "\e[1;31m* [12]\e[0m \e[1;32m: Extending XRAY Vless\e[0m"
echo -e "\e[1;31m* [x]\e[0m \e[1;32m:  Menu\e[0m"
echo -e ""
read -p "        Select From Options [1-12 or x]: " menuxray
echo -e ""
case $menuxray in
1)
add-xws
;;
2)
add-xvless
;;
3)
add-xray
;;
4)
del-xray
;;
5)
del-xws
;;
6)
del-xvless
;;
7)
cek-xws
;;
8)
cek-xvless
;;
9)
cek-xray
;;
10)
renew-xray
;;
11)
renew-xws
;;
12)
renew-xvless
;;
x)
menu
;;
*)
echo " Please enter an correct number!!"
;;
esac
