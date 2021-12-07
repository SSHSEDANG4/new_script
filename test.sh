#protocol 1
{
    "log": {
        "loglevel": "none"
    },
    "inbounds": [
        {
            "port": 443,
            "protocol": "vless",
            "settings": {
                "clients": [
                    {
                        "id": "$xid_1",
                        "flow": "xtls-rprx-direct"
                    }
                ],
                          "decryption": "none",'
                          "fallbacks": [' 
    
                    {
                        "alpn": "h2",
                        "dest": "/dev/shm/nginx_unixsocket/h2.sock"
                    },
                    {
                        "dest": "/dev/shm/nginx_unixsocket/default.sock"
                    }
                ]
            },
            "streamSettings": {
                "network": "tcp",
                "security": "xtls",
                "xtlsSettings": {
                    "alpn": [
                        "h2",
                        "http/1.1"
                    ],
                    "minVersion": "1.2",
                    "cipherSuites": "TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256:TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384:TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305_SHA256",
                    "certificates": [
                        {
                            "certificateFile": "${nginx_prefix}/certs/${true_domain_list[$i]}.cer",
                            "keyFile": "${nginx_prefix}/certs/${true_domain_list[$i]}.key",
                            "ocspStapling": 3600
                    ]
                }
            }
            },
            "streamSettings": {
                "network": "grpc",
                "grpcSettings": {
                    "serviceName": "$serviceName"
                }
            }
            },
            "streamSettings": {
                "network": "ws",
                "wsSettings": {
                    "path": "$path"
                }
            }
        }
    ],
    "outbounds": [
        {
            "protocol": "freedom"
        }
    ]
}
EOF


#protocol 2
{
    "log": {
        "loglevel": "none"
    },
    "inbounds": [
        {
            "port": 443,
            "protocol": "vless",
            "settings": {
{
                    {
                        "alpn": "h2",
                        "dest": "/dev/shm/nginx_unixsocket/h2.sock"
                    },
                    {
                        "dest": "/dev/shm/nginx_unixsocket/default.sock"
                    }
                ]
            },
            "streamSettings": {
                "network": "tcp",
                "security": "xtls",
                "xtlsSettings": {
                    "alpn": [
                        "h2",
                        "http/1.1"
                    ],
                    "minVersion": "1.2",
                    "cipherSuites": "TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256:TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384:TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305_SHA256",
                    "certificates": [
                        {
                            "certificateFile": "${nginx_prefix}/certs/${true_domain_list[$i]}.cer",
                            "keyFile": "${nginx_prefix}/certs/${true_domain_list[$i]}.key",
                            "ocspStapling": 3600
                    ]
                }
            }
