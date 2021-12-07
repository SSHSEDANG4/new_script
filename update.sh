#!/bin/bash
# // Update
apt-get -y autoremove;
apt upgrade && apt replace -y

echo "Start Update"
sleep 5

# // Download
cd /usr/bin
wget -O menu-xws "https://raw.githubusercontent.com/faiz007t/bc/main/menu.sh"
chmod +x menu-xws
echo "0 5 * * * root clear-log && reboot" > /etc/crontab
echo "0 0 * * * root xp" > /etc/crontab
cd
echo "1.2" > /home/ver
clear
echo " Fix minor Bugs"
echo " Now You Can Change Port Of Some Services"
echo " Reboot 5 Sec"
sleep 5
rm -f update.sh
reboot
