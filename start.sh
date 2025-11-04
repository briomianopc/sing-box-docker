#!/bin/sh

PORT=8080

cat <<EOF > /etc/sing-box/config.json
{
  "log": {
    "level": "info",
    "timestamp": true
  },
  "dns": {
    "servers": [
      { "address": "https://1.1.1.1/dns-query", "detour": "direct" }
    ]
  },
  "inbounds": [
    {
      "type": "vless",
      "tag": "vless-ws-in",
      "listen": "::",
      "listen_port": "$PORT",
      "users": [
        {
          "uuid": "f4b1f1a5-5a5a-4b5a-8a8a-1a2b3c4d5e6f",
          "flow": ""
        }
      ],
      "tls": {
        "enabled": false
      },
      "transport": {
        "type": "ws",
        "path": "/laowang",
        "max_early_data": 0,
        "early_data_header_name": ""
      }
    }
  ],
  "outbounds": [
    {
      "type": "direct",
      "tag": "direct"
    },
    {
      "type": "block",
      "tag": "block"
    }
  ],
  "route": {
    "rules": [
      {
        "inbound": ["vless-ws-in"],
        "outbound": "direct"
      }
    ]
  }
}
EOF
