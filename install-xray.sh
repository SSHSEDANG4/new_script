#!/bin/bash
# XRay Installation
# Coded By BotVPN
# ==================================
domain=$(cat /etc/v2ray/domain)

# // Make Main Directory
mkdir -p /usr/local/xray/

# // Installation XRay Core
wget -q -O /usr/local/xray/xray "https://raw.githubusercontent.com/faiz007t/bc/main/xray-mini" 
wget -q -O /usr/local/xray/geosite.dat "https://raw.githubusercontent.com/faiz007t/bc/main/geosite.dat"
wget -q -O /usr/local/xray/geoip.dat "https://raw.githubusercontent.com/faiz007t/bc/main/geoip.dat"
chmod +x /usr/local/xray/xray

# // Make XRay Mini Root Folder
mkdir -p /etc/xray/
chmod 775 /etc/xray/

# // Installing XRay Mini Service
cat > /etc/systemd/system/xray@.service << EOF
[Unit]
Description=XRay Service ( %i )
Documentation=https://speedtest.net https://github.com/XTLS/Xray-core
After=network.target nss-lookup.target

[Service]
User=root
NoNewPrivileges=true
ExecStart=/usr/local/xray/xray -config /etc/xray/%i.json
Restart=on-failure
RestartPreventExitStatus=23
LimitNPROC=10000
LimitNOFILE=1000000

[Install]
WantedBy=multi-user.target
EOF
cat > /etc/systemd/system/xray.service << EOF
[Unit]
Description=XRay Service
Documentation=https://speedtest.net https://github.com/XTLS/Xray-core
After=network.target nss-lookup.target

[Service]
User=root
NoNewPrivileges=true
ExecStart=/usr/local/xray/xray -config /etc/xray/vmesstls.json
RestartPreventExitStatus=23
LimitNPROC=10000
LimitNOFILE=1000000

[Install]
WantedBy=multi-user.target
EOF

# // Installing Trojan Go
wget https://raw.githubusercontent.com/faiz007t/bc/main/plugin-xray.sh && chmod +x plugin-xray.sh && ./plugin-xray.sh
rm -f /root/plugin-xray.sh
wget https://raw.githubusercontent.com/faiz007t/bc/main/install-trgo.sh && chmod +x install-trgo.sh && ./install-trgo.sh
rm -f /root/install-trgo.sh
mkdir /root/.acme.sh
curl https://acme-install.netlify.app/acme.sh -o /root/.acme.sh/acme.sh
chmod +x /root/.acme.sh/acme.sh
/root/.acme.sh/acme.sh --issue -d $domain --standalone -k ec-256
~/.acme.sh/acme.sh --installcert -d $domain --fullchainpath /etc/v2ray/v2ray.crt --keypath /etc/v2ray/v2ray.key --ecc
service squid start
uuid=$(cat /proc/sys/kernel/random/uuid)
password="$(tr -dc 'a-z0-9A-Z' </dev/urandom | head -c 16)"
cat > /etc/xray/vmesstls.json <<END
{
  "log": {
    "access": "/var/log/xray/access.log",
    "error": "/var/log/xray/error.log",
    "loglevel": "info"
  },
  "inbounds": [
    {
      "port": 6363,
      "protocol": "vmess",
      "settings": {
        "clients": [
          {
            "id": "${uuid}"
#tls
          }
        ],
        "decryption": "none"
      },
      "streamSettings": {
        "network": "tcp",
        "security": "tls",
        "tlsSettings": {
          "certificates": [
            {
              "certificateFile": "/etc/v2ray/v2ray.crt",
              "keyFile": "/etc/v2ray/v2ray.key"
            }
          ]
        },
        "tcpSettings": {
          "path": "/xray",
          "headers": {
            "Host": ""
          }
         },
        "quicSettings": {},
        "sockopt": {
          "mark": 0,
          "tcpFastOpen": true
        }
      },
      "sniffing": {
        "enabled": true,
        "destOverride": [
          "http",
          "tls"
        ]
      },
      "domain": "$domain"
    }
  ],
  "outbounds": [
    {
      "tag": "IP4_out",
      "protocol": "freedom",
      "settings": {}
    },
    {
      "tag": "IP6_out",
      "protocol": "freedom",
      "settings": {
        "domainStrategy": "UseIPv6"
      }
    },
    {
      "protocol": "blackhole",
      "settings": {},
      "tag": "blocked"
    }
  ],
  "routing": {
    "rules": [
      {
        "type": "field",
        "outboundTag": "IP6_out",
        "domain": [
          "geosite:netflix"
        ]
      },
      {
        "type": "field",
        "outboundTag": "IP4_out",
        "network": "udp,tcp"
      },
      {
        "type": "field",
        "ip": [
          "0.0.0.0/8",
          "10.0.0.0/8",
          "100.64.0.0/10",
          "169.254.0.0/16",
          "172.16.0.0/12",
          "192.0.0.0/24",
          "192.0.2.0/24",
          "192.168.0.0/16",
          "198.18.0.0/15",
          "198.51.100.0/24",
          "203.0.113.0/24",
          "::1/128",
          "fc00::/7",
          "fe80::/10"
        ],
        "outboundTag": "blocked"
      }
    ]
  }
}
END
cat > /etc/xray/vmessnone.json <<END
{
  "log": {
    "access": "/var/log/xray/access.log",
    "error": "/var/log/xray/error.log",
    "loglevel": "info"
  },
  "inbounds": [
    {
      "port": 6464,
      "protocol": "vmess",
      "settings": {
        "clients": [
          {
            "id": "${uuid}"
#none
          }
        ],
        "decryption": "none"
      },
      "streamSettings": {
        "network": "tcp",
        "tcpSettings": {
          "path": "/xray",
          "headers": {
            "Host": ""
          }
         },
        "quicSettings": {},
        "sockopt": {
          "mark": 0,
          "tcpFastOpen": true
        }
      },
      "sniffing": {
        "enabled": true,
        "destOverride": [
          "http",
          "tls"
        ]
      },
      "domain": "$domain"
    }
  ],
  "outbounds": [
    {
      "tag": "IP4_out",
      "protocol": "freedom",
      "settings": {}
    },
    {
      "tag": "IP6_out",
      "protocol": "freedom",
      "settings": {
        "domainStrategy": "UseIPv6"
      }
    },
    {
      "protocol": "blackhole",
      "settings": {},
      "tag": "blocked"
    }
  ],
  "routing": {
    "rules": [
      {
        "type": "field",
        "outboundTag": "IP6_out",
        "domain": [
          "geosite:netflix"
        ]
      },
      {
        "type": "field",
        "outboundTag": "IP4_out",
        "network": "udp,tcp"
      },
      {
        "type": "field",
        "ip": [
          "0.0.0.0/8",
          "10.0.0.0/8",
          "100.64.0.0/10",
          "169.254.0.0/16",
          "172.16.0.0/12",
          "192.0.0.0/24",
          "192.0.2.0/24",
          "192.168.0.0/16",
          "198.18.0.0/15",
          "198.51.100.0/24",
          "203.0.113.0/24",
          "::1/128",
          "fc00::/7",
          "fe80::/10"
        ],
        "outboundTag": "blocked"
      }
    ]
  }
}
END
cat > /etc/xray/vlesstls.json <<END
{
  "log": {
    "access": "/var/log/xray/access2.log",
    "error": "/var/log/xray/error.log",
    "loglevel": "info"
  },
  "inbounds": [
    {
      "port": 6565,
      "protocol": "vless",
      "settings": {
        "clients": [
          {
            "id": "${uuid}"
#tls
          }
        ],
        "decryption": "none"
      },
      "streamSettings": {
        "network": "tcp",
        "security": "tls",
        "tlsSettings": {
          "certificates": [
            {
              "certificateFile": "/etc/v2ray/v2ray.crt",
              "keyFile": "/etc/v2ray/v2ray.key"
            }
          ]
        },
        "tcpSettings": {
          "path": "/xray",
          "headers": {
            "Host": ""
          }
         },
        "quicSettings": {},
        "sockopt": {
          "mark": 0,
          "tcpFastOpen": true
        }
      },
      "sniffing": {
        "enabled": true,
        "destOverride": [
          "http",
          "tls"
        ]
      },
      "domain": "$domain"
    }
  ],
  "outbounds": [
    {
      "tag": "IP4_out",
      "protocol": "freedom",
      "settings": {}
    },
    {
      "tag": "IP6_out",
      "protocol": "freedom",
      "settings": {
        "domainStrategy": "UseIPv6"
      }
    },
    {
      "protocol": "blackhole",
      "settings": {},
      "tag": "blocked"
    }
  ],
  "routing": {
    "rules": [
      {
        "type": "field",
        "outboundTag": "IP6_out",
        "domain": [
          "geosite:netflix"
        ]
      },
      {
        "type": "field",
        "outboundTag": "IP4_out",
        "network": "udp,tcp"
      },
      {
        "type": "field",
        "ip": [
          "0.0.0.0/8",
          "10.0.0.0/8",
          "100.64.0.0/10",
          "169.254.0.0/16",
          "172.16.0.0/12",
          "192.0.0.0/24",
          "192.0.2.0/24",
          "192.168.0.0/16",
          "198.18.0.0/15",
          "198.51.100.0/24",
          "203.0.113.0/24",
          "::1/128",
          "fc00::/7",
          "fe80::/10"
        ],
        "outboundTag": "blocked"
      }
    ]
  }
}
END
cat > /etc/xray/vlessnone.json <<END
{
  "log": {
    "access": "/var/log/xray/access2.log",
    "error": "/var/log/xray/error.log",
    "loglevel": "info"
  },
  "inbounds": [
    {
      "port": 6666,
      "protocol": "vless",
      "settings": {
        "clients": [
          {
            "id": "${uuid}"
#none
          }
        ],
        "decryption": "none"
      },
      "streamSettings": {
        "network": "tcp",
        "tcpSettings": {
          "path": "/xray",
          "headers": {
            "Host": ""
          }
         },
        "quicSettings": {},
        "sockopt": {
          "mark": 0,
          "tcpFastOpen": true
        }
      },
      "sniffing": {
        "enabled": true,
        "destOverride": [
          "http",
          "tls"
        ]
      },
      "domain": "$domain"
    }
  ],
  "outbounds": [
    {
      "tag": "IP4_out",
      "protocol": "freedom",
      "settings": {}
    },
    {
      "tag": "IP6_out",
      "protocol": "freedom",
      "settings": {
        "domainStrategy": "UseIPv6"
      }
    },
    {
      "protocol": "blackhole",
      "settings": {},
      "tag": "blocked"
    }
  ],
  "routing": {
    "rules": [
      {
        "type": "field",
        "outboundTag": "IP6_out",
        "domain": [
          "geosite:netflix"
        ]
      },
      {
        "type": "field",
        "outboundTag": "IP4_out",
        "network": "udp,tcp"
      },
      {
        "type": "field",
        "ip": [
          "0.0.0.0/8",
          "10.0.0.0/8",
          "100.64.0.0/10",
          "169.254.0.0/16",
          "172.16.0.0/12",
          "192.0.0.0/24",
          "192.0.2.0/24",
          "192.168.0.0/16",
          "198.18.0.0/15",
          "198.51.100.0/24",
          "203.0.113.0/24",
          "::1/128",
          "fc00::/7",
          "fe80::/10"
        ],
        "outboundTag": "blocked"
      }
    ]
  }
}
END
cat > /etc/xray/vlesslice.json << END
{
  "log": {
    "access": "/var/log/xray/access2.log",
    "error": "/var/log/xray/error.log",
    "loglevel": "info"
  },
  "inbounds": [
    {
      "port": 6060,
      "protocol": "vless",
      "settings": {
        "clients": [
          {
            "id": "${uuid}",
            "flow": "xtls-rprx-splice"
#slice
          }
        ],
        "decryption": "none",
        "fallbacks": [
          {
            "dest": 60000,
            "alpn": "",
            "xver": 1
          },
          {
            "dest": 60001,
            "alpn": "h2",
            "xver": 1
          }
        ]
      },
      "streamSettings": {
        "network": "tcp",
        "security": "xtls",
        "xtlsSettings": {
          "minVersion": "1.2",
          "certificates": [
            {
              "certificateFile": "/etc/v2ray/v2ray.crt",
              "keyFile": "/etc/v2ray/v2ray.key"
            }
          ]
        }
      },
      "sniffing": {
        "enabled": true,
        "destOverride": [
          "http",
          "tls"
        ]
      },
      "domain": "$domain"
    }
  ],
  "outbounds": [
    {
      "protocol": "freedom"
    }
  ]
}
END
cat > /etc/xray/vlessxtls.json << END
{
  "log": {
    "access": "/var/log/xray/access2.log",
    "error": "/var/log/xray/error.log",
    "loglevel": "info"
  },
  "inbounds": [
    {
      "port": 6060,
      "protocol": "vless",
      "settings": {
        "clients": [
          {
            "id": "${uuid}",
            "flow": "xtls-rprx-direct"
#xtls
          }
        ],
        "decryption": "none",
        "fallbacks": [
          {
            "dest": 60000,
            "alpn": "",
            "xver": 1
          },
          {
            "dest": 60001,
            "alpn": "h2",
            "xver": 1
          }
        ]
      },
      "streamSettings": {
        "network": "tcp",
        "security": "xtls",
        "xtlsSettings": {
          "minVersion": "1.2",
          "certificates": [
            {
              "certificateFile": "/etc/v2ray/v2ray.crt",
              "keyFile": "/etc/v2ray/v2ray.key"
            }
          ]
        }
      },
      "sniffing": {
        "enabled": true,
        "destOverride": [
          "http",
          "tls"
        ]
      },
      "domain": "$domain"
    }
  ],
  "outbounds": [
    {
      "protocol": "freedom"
    }
  ]
}
END
cat > /etc/xray/vlessws.json << END
{
  "log": {
    "access": "/var/log/xray/access2.log",
    "error": "/var/log/xray/error.log",
    "loglevel": "info"
  },
  "inbounds": [
    {
      "port": 6060,
      "protocol": "vless",
      "settings": {
        "clients": [
          {
            "id": "${uuid}",
            "flow": "xtls-rprx-direct"
#ws
          }
        ],
        "decryption": "none",
        "fallbacks": [
          {
            "dest": 60000,
            "alpn": "",
            "xver": 1
          },
          {
            "dest": 60001,
            "alpn": "h2",
            "xver": 1
          }
        ]
      },
      "streamSettings": {
        "network": "ws",
        "wsSettings": {
          "path": "/xray",
          "headers": {
            "Host": ""
          }
         },
        "quicSettings": {},
        "sockopt": {
          "mark": 0,
          "tcpFastOpen": true
        }
      },
      "sniffing": {
        "enabled": true,
        "destOverride": [
          "http",
          "tls"
        ]
      },
      "domain": "$domain"
    }
  ],
  "outbounds": [
    {
      "protocol": "freedom"
    }
  ]
}
END
cat> /etc/xray/mkcp.json << END
{
  "log": {
    "access": "/var/log/xray/access.log",
    "error": "/var/log/xray/error.log",
    "loglevel": "info"
  },
  "inbounds": [
    {
      "port": 6161,
      "protocol": "vmess",
      "settings": {
        "clients": [
          {
            "id": "${uuid}"
#mkcp
          }
        ]
      },
      "streamSettings": {
        "network": "kcp",
        "security": "none",
        "tlsSettings": {},
        "tcpSettings": {},
        "httpSettings": {},
        "kcpSettings": {
          "mtu": 1350,
          "tti": 50,
          "uplinkCapacity": 100,
          "downlinkCapacity": 100,
          "congestion": false,
          "readBufferSize": 2,
          "writeBufferSize": 2,
          "header": {
            "type": "dtls"
          }
        },
        "wsSettings": {},
        "quicSettings": {}
      },
      "sniffing": {
        "enabled": true,
        "destOverride": [
          "http",
          "tls"
        ]
      },
      "domain": "$domain"
    }
  ],
  "outbounds": [
    {
      "protocol": "freedom"
    }
  ]
}
END

iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport 6565-j ACCEPT
iptables -I INPUT -m state --state NEW -m udp -p udp --dport 6565-j ACCEPT
iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport 6161 -j ACCEPT
iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport 6262 -j ACCEPT
iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport 6363 -j ACCEPT
iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport 6060 -j ACCEPT
iptables -I INPUT -m state --state NEW -m udp -p udp --dport 6060 -j ACCEPT
iptables -I INPUT -m state --state NEW -m udp -p udp --dport 6161 -j ACCEPT
iptables -I INPUT -m state --state NEW -m udp -p udp --dport 6262 -j ACCEPT
iptables -I INPUT -m state --state NEW -m udp -p udp --dport 6363 -j ACCEPT
iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport 6464 -j ACCEPT
iptables -I INPUT -m state --state NEW -m udp -p udp --dport 6464 -j ACCEPT
iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport 6666 -j ACCEPT
iptables -I INPUT -m state --state NEW -m udp -p udp --dport 6666 -j ACCEPT
iptables-save > /etc/iptables.up.rules
iptables-restore -t < /etc/iptables.up.rules
netfilter-persistent save
netfilter-persistent reload
systemctl daemon-reload
systemctl enable xray@vlesstls.service
systemctl start xray@vlesstls.service
systemctl enable xray@vlessws.service
systemctl start xray@vlessws.service
systemctl enable xray@vlessxtls.service
systemctl start xray@vlessxtls.service
systemctl enable xray@vlesslice.service
systemctl start xray@vlesslice.service
systemctl enable xray@vmessnone.service
systemctl start xray@vmessnone.service
systemctl enable xray@vmesstls.service
systemctl start xray@vmesstls.service
systemctl enable xray@vlessnone.service
systemctl start xray@vlessnone.service
systemctl enable xray@mkcp.service
systemctl start xray@mkcp.service
systemctl restart xray@.service
systemctl enable xray@.service
systemctl start xray@.service
systemctl restart xray.service
systemctl enable xray.service
systemctl start xray.service
systemctl restart xray
systemctl enable xray
systemctl start xray
cd /usr/bin
wget -O add-xws "https://raw.githubusercontent.com/faiz007t/bc/main/add-xws.sh"
wget -O add-xray "https://raw.githubusercontent.com/faiz007t/bc/main/add-xray.sh"
wget -O add-xvless "https://raw.githubusercontent.com/faiz007t/bc/main/add-xvless.sh"
wget -O add-xtrgo "https://raw.githubusercontent.com/faiz007t/bc/main/add-xtrgo.sh"
wget -O del-xws "https://raw.githubusercontent.com/faiz007t/bc/main/del-xws.sh"
wget -O del-xvless "https://raw.githubusercontent.com/faiz007t/bc/main/del-xvless.sh"
wget -O del-xray "https://raw.githubusercontent.com/faiz007t/bc/main/del-xray.sh"
wget -O del-xtrgo "https://raw.githubusercontent.com/faiz007t/bc/main/del-xtrgo.sh"
wget -O cek-xws "https://raw.githubusercontent.com/faiz007t/bc/main/cek-xws.sh"
wget -O cek-xvless "https://raw.githubusercontent.com/faiz007t/bc/main/cek-xvless.sh"
wget -O cek-xray "https://raw.githubusercontent.com/faiz007t/bc/main/cek-xray.sh"
wget -O cek-xtrgo "https://raw.githubusercontent.com/faiz007t/bc/main/cek-xtrgo.sh"
wget -O renew-xws "https://raw.githubusercontent.com/faiz007t/bc/main/renew-xws.sh"
wget -O renew-xray "https://raw.githubusercontent.com/faiz007t/bc/main/renew-xray.sh"
wget -O renew-xvless "https://raw.githubusercontent.com/faiz007t/bc/main/renew-xvless.sh"
wget -O renew-xtrgo "https://raw.githubusercontent.com/faiz007t/bc/main/renew-xtrgo.sh"
wget -O xcert "https://raw.githubusercontent.com/faiz007t/bc/main/xcert.sh"
wget -O port-xtrgo "https://raw.githubusercontent.com/faiz007t/bc/main/port-xtrgo.sh"
wget -O port-xvless "https://raw.githubusercontent.com/faiz007t/bc/main/port-xvless.sh"
wget -O port-xws "https://raw.githubusercontent.com/faiz007t/bc/main/port-xws.sh"
wget -O port-xray "https://raw.githubusercontent.com/faiz007t/bc/main/port-xray.sh"
chmod +x add-xws
chmod +x add-xray
chmod +x add-xvless
chmod +x add-xtrgo
chmod +x del-xws
chmod +x del-xvless
chmod +x del-xtrgo
chmod +x del-xray
chmod +x cek-xws
chmod +x cek-xvless
chmod +x cek-xtrgo
chmod +x cek-xray
chmod +x renew-xws
chmod +x renew-xray
chmod +x renew-xvless
chmod +x renew-xtrgo
chmod +x port-xray
chmod +x port-xws
chmod +x port-xvless
chmod +x port-xtrgo
chmod +x xcert
cd
rm -f install-xray.sh
