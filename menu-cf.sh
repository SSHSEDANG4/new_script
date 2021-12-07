#!/bin/bash
DF='\e[39m'
Bold='\e[1m'
Blink='\e[5m'
yell='\e[33m'
red='\e[31m'
green='\e[32m'
blue='\e[34m'
PURPLE='\e[35m'
CYAN='\e[36m'
Lred='\e[91m'
Lgreen='\e[92m'
Lyellow='\e[93m'
NC='\e[0m'
MYIP=$(wget -qO- ifconfig.co);
echo "Checking VPS"
#EDIT IZIN
clear 
echo -e  "$PURPLE  .-------------------------------------------------------."
echo -e  "$PURPLE  |                      $Blink $yell  Domain Menu$NC                   $PURPLE|"
echo -e  "$PURPLE  '-------------------------------------------------------'$NC"
echo -e "   $green 1)$NC $yell Add domain Host For VPS$NC"
echo -e "   $green 2)$NC $yell Add ID Cloudflare$NC"
echo -e "   $green 3)$NC $yell Cloudflare Add-Ons$NC"
echo -e "   $green 4)$NC $yell Pointing BUG$NC"
echo -e "   $green 5)$NC $yell Renew Certificate V2RAY$NC"
echo -e "   $green 6)$NC $yell BACK TO MENU$NC"
echo -e  "$PURPLE  .-------------------------------------------------------."
echo -e  "$PURPLE  |                $yell Script status : Premium$NC               $PURPLE|"
echo -e  "$PURPLE  '-------------------------------------------------------'$NC"
echo -e ""
read -p "     Please Input Number  [1-6 or x] :  "  opt
echo -e ""
case $opt in
1) clear ; add-host ;;
2) clear ; add-cff ;;
3) clear ; add-dom ;;
4) clear ; add-cfh ;;
5) clear ; certv2ray ;;
6) clear ; menu ;;
*) echo "Please enter an correct number" ;;
esac
