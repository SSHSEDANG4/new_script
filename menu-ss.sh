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
echo -e "\e[94m  |               Shadowsocks OBFS MENU                |    "
echo -e "\e[94m  '----------------------------------------------------'    "
echo -e "\e[0m                                                               "
echo -e "\e[1;31m* [1]\e[0m \e[1;32m: Creating Shadowsocks Account\e[0m"
echo -e "\e[1;31m* [2]\e[0m \e[1;32m: Delete Shadowsocks Account\e[0m"
echo -e "\e[1;31m* [3]\e[0m \e[1;32m: Extending Shadowsocks Account Active Life\e[0m"
echo -e "\e[1;31m* [4]\e[0m \e[1;32m: Check User Login Shadowsocks\e[0m"
echo -e ""
echo -e ""
read -p "        Select From Options [1-4 or x]: " menuss
echo -e ""
case $menuss in
1)
add-ss
;;
2)
del-ss
;;
3)
renew-ss
;;
4)
cek-ss
;;
x)
menu
;;
*)
echo " Please enter an correct number!!"
;;
esac
