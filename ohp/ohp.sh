#!/bin/bash
# Open HTTP Puncher By BotVPN
red='\e[1;31m'
green='\e[0;32m'
NC='\e[0m'
MYIP=$(wget -qO- ipinfo.io/ip);
IZIN=$( curl https://raw.githubusercontent.com/SSHSEDANG4/kunci_script/main/iptext.sh | grep $MYIP )
if [ $MYIP = $IZIN ]; then
clear
echo -e "${green} Please Wait, Proses...${NC}"
sleep 5
else
echo "User premium Only ,Sila Contact Admin"
exit 0
fi
clear
# Direct Proxy Squid For OpenVPN TCP

RED='\e[1;31m'
GREEN='\e[0;32m'
BLUE='\e[0;34m'
NC='\e[0m'
MYIP=$(wget -qO- https://icanhazip.com);
MYIP2="s/xxxxxxxxx/$MYIP/g";

# Update Repository VPS
clear
apt update 
apt-get -y upgrade

# Port Server
Port_OpenVPN_TCP='1194';
Port_Squid='3128';
Port_OHP='8282';
Port_Dropbear='8181';
Port_ssh='8383';

# Installing ohp Server
cd 
wget -O /usr/local/bin/ohp "https://raw.githubusercontent.com/faiz007t/bc/main/ohp/ohp"
chmod +x /usr/local/bin/ohp

# Buat File OpenVPN TCP OHP
cat > /etc/openvpn/tcp-ohp.ovpn <<END
setenv CLIENT_CERT 0
setenv opt block-outside-dns
client
dev tun
proto tcp
remote "bug" 1194
persist-tun
persist-key
persist-remote-ip
comp-lzo
reneg-sec 0
pull
resolv-retry infinite
remote-cert-tls server
verb 3
auth-user-pass
cipher none
auth none
auth-nocache
script-security 2
tls-version-min 1.2
tls-cipher TLS-ECDHE-ECDSA-WITH-AES-128-GCM-SHA256
http-proxy xxxxxxxxx 8282
http-proxy-option VERSION 1.1
http-proxy-option CUSTOM-HEADER ""
http-proxy-option CUSTOM-HEADER "Host: "
http-proxy-option CUSTOM-HEADER "X-Forwarded-Host: "
http-proxy-option CUSTOM-HEADER ""
END
sed -i $MYIP2 /etc/openvpn/tcp-ohp.ovpn;

# masukkan certificatenya ke dalam config client TCP 1194
echo '<ca>' >> /etc/openvpn/tcp-ohp.ovpn
cat /etc/openvpn/server/ca.crt >> /etc/openvpn/tcp-ohp.ovpn
echo '</ca>' >> /etc/openvpn/tcp-ohp.ovpn
cp /etc/openvpn/tcp-ohp.ovpn /home/vps/public_html/tcp-ohp.ovpn
clear
cd 

# Buat Service Untuk OHP
wget https://github.com/lfasmpao/open-http-puncher/releases/download/0.1/ohpserver-linux32.zip
unzip ohpserver-linux32.zip
rm ohpserver-linux32.zip
mv ohpserver /usr/local/bin/
chmod +x /usr/local/bin/ohpserver

cat > /etc/systemd/system/dropbear-ohp.service << END
[Unit]
Description=DROPBEAR OHP Redirection Service
Documentation=https://t.me/sshsedang4
After=network.target nss-lookup.target

[Service]
Type=simple
User=root
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
NoNewPrivileges=true
ExecStart=/usr/local/bin/ohpserver -port 8181 -proxy 127.0.0.1:3128 -tunnel 127.0.0.1:143
Restart=on-failure
LimitNOFILE=infinity

[Install]
WantedBy=multi-user.target

END

cat > /etc/systemd/system/ovpn-ohp.service << END

[Unit]
Description=OpenVPN OHP Redirection Service
Documentation=https://t.me/onepiecevpn
After=network.target nss-lookup.target

[Service]
Type=simple
User=root
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
NoNewPrivileges=true
ExecStart=/usr/local/bin/ohpserver -port 8282 -proxy 127.0.0.1:3128 -tunnel 127.0.0.1:1194
Restart=on-failure
LimitNOFILE=infinity

[Install]
WantedBy=multi-user.target

END
cat > /etc/systemd/system/dropbear-ohp.service << END
[Unit]
Description=DROPBEAR OHP Redirection Service
Documentation=https://t.me/sshsedang4
After=network.target nss-lookup.target

[Service]
Type=simple
User=root
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
NoNewPrivileges=true
ExecStart=/usr/local/bin/ohpserver -port 8181 -proxy 127.0.0.1:3128 -tunnel 127.0.0.1:143
Restart=on-failure
LimitNOFILE=infinity

[Install]
WantedBy=multi-user.target

END

cat > /etc/systemd/system/ssh-ohp.service << END

[Unit]
Description=OpenVPN OHP Redirection Service
Documentation=https://t.me/sshsedang4
After=network.target nss-lookup.target

[Service]
Type=simple
User=root
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
NoNewPrivileges=true
ExecStart=/usr/local/bin/ohpserver -port 8383 -proxy 127.0.0.1:22 -tunnel 127.0.0.1:22
Restart=on-failure
LimitNOFILE=infinity

[Install]
WantedBy=multi-user.target

END
systemctl enable dropbear-ohp.service 
systemctl enable ovpn-ohp.service 
systemctl enable ssh-ohp.service
systemctl start dropbear-ohp.service 
systemctl start ovpn-ohp.service
systemctl start ssh-ohp.service
systemctl daemon-reload
systemctl enable ohp
systemctl restart ohp
echo ""
echo -e "${GREEN}Done Installing OHP Server${NC}"
echo -e "Port Dropbear OHP: $Port_Dropbear"
echo -e "Port OVPN OHP TCP: $Port_OHP"
echo -e "Porr SSH OHP     : $Port_ssh"
echo -e "Link Download OVPN OHP: http://$MYIP:81/tcp-ohp.ovpn"
echo -e "Script By SSH SEDANG NETWORK"
