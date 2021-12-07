#!/bin/bash
read -p "Username : " Login
read -p "Password : " Pass
read -p "Expired (hari): " masaaktif
IP=$(wget -qO- icanhazip.com);
domain=$(cat /etc/v2ray/domain);
IP=$(wget -qO- ipinfo.io/ip);
ssl="$(cat ~/log-install.txt | grep -w "Stunnel4" | cut -d: -f2)"
sqd="$(cat ~/log-install.txt | grep -w "Squid" | cut -d: -f2)"
ovpn="$(netstat -nlpt | grep -i openvpn | grep -i 0.0.0.0 | awk '{print $4}' | cut -d: -f2)"
ovpn2="$(netstat -nlpu | grep -i openvpn | grep -i 0.0.0.0 | awk '{print $4}' | cut -d: -f2)"
sleep 1
echo Ping Host
echo Cek Hak Akses...
sleep 0.5
echo Permission Accepted
clear
sleep 0.5
echo Membuat Akun: $Login
sleep 0.5
echo Setting Password: $Pass
sleep 0.5
clear
useradd -e `date -d "$masaaktif days" +"%Y-%m-%d"` -s /bin/false -M $Login
dibuat=$(date +"%b %C, %Y")
exp="$(chage -l $Login | grep "Account expires" | awk -F": " '{print $2}')"
echo -e "$Pass\n$Pass\n"|passwd $Login &> /dev/null
echo -e ""
echo -e "==================================" 
echo -e "Information SSH & OpenVPN Account " | lolcat
echo -e "==================================" 
echo -e "Domain       : $domain"
echo -e "Host         : $IP"
echo -e "Username     : $Login "
echo -e "Password             : $Pass"
echo -e "=================================="
echo -e "OpenSSH      : 22"
echo -e "Dropbear     : 143,777"
echo -e "SSL/TL       : $ssl"
echo -e "WS Dropbear  : 8880"
echo -e "WS OpenSSH   : 2095"
echo -e "WS OpenVPN   : 2082"
echo -e "WS TLS       : 2088"
echo -e "OHP OpenVPN  : 8282"
echo -e "OHP DropBear : 8181"
echo -e "OHP OpenSSH  : 8383"
echo -e "Port Squid   : $sqd"
echo -e "OpenVPN TCP  : http://$IP:81/client-tcp-$ovpn.ovpn"
echo -e "OpenVPN UDP  : http://$IP:81/client-udp-$ovpn2.ovpn"
echo -e "OpenVPN SSL  : http://$IP:81/client-tcp-ssl.ovpn"
echo -e "OpenVPN OHP  : http://$IP:81/tcp-ohp.ovpn"
echo -e "Badvpn UDPGW : 7100, 7200, 7300"
echo -e "================================"
echo -e "Payload WebSocket"
echo -e "GET / HTTP/1.1[crlf]Host: bug.com.$domain[crlf]Connection: Keep-Alive[crlf]User-Agent: [ua][crlf]Upgrade: websocket[crlf][crlf]"
echo -e "================================"
echo -e "Payload WebSocket"
echo -e "GET / HTTP/1.1[crlf]Host: bug.com.$domain[crlf]Upgrade: websocket[crlf][crlf]"                                                                  
echo -e "================================"
echo -e "Payload WebSocket"
echo -e "GET wss://bug.com/ HTTP/1.1[crlf]Host: bug.com.$domain[crlf]Upgrade: websocket[crlf]Connection: Keep-Alive[crlf][crlf]"
echo -e "================================"
echo -e "Http:Custom"
echo -e "bug.com:8880@$Login:$Pass"
echo -e "================================"
echo -e "Active Days    : $masaaktif Days"
echo -e "Created On     : $dibuat"
echo -e "Expired On     : $exp"
echo -e "===================================="
echo -e "Script Created By ONEPIECECREW" | lolcat
echo -e ""
