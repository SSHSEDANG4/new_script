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
echo -e "\e[94m  |                     WIREGUARD MENU                 |    "
echo -e "\e[94m  '----------------------------------------------------'    "
echo -e "\e[0m                                                               "
echo -e "\e[1;31m* [1]\e[0m \e[1;32m: Create Wireguard Account\e[0m"
echo -e "\e[1;31m* [2]\e[0m \e[1;32m: Delete Wireguard Account\e[0m"
echo -e "\e[1;31m* [3]\e[0m \e[1;32m: Check User Login Wireguard\e[0m"
echo -e "\e[1;31m* [4]\e[0m \e[1;32m: Extending Wireguard Account Active Life\e[0m"
echo -e "\e[1;31m* [5]\e[0m \e[1;32m: Check Wireguard User Interface\e[0m"
echo -e ""
echo -e ""
read -p "        Select From Options [1-5 or x]: " menuwg
echo -e ""
case $menuwg in
1)
add-wg
;;
2)
del-wg
;;
3)
cek-wg
;;
4)
renew-wg
;;
5)
wg show
;;
x)
menu
;;
*)
echo " Please enter an correct number!!"
;;
esac
