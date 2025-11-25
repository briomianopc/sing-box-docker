#!/bin/sh

# 设置默认值
UUID=${UUID:-"f4b1f1a5-5a5a-4b5a-8a8a-1a2b3c4d5e6f"}
WS_PATH=${WS_PATH:-"/laowang"}
PORT=${PORT:-8080}

# 检测是否使用 Cloudflare Tunnel
if [ -n "$CLOUDFLARE_TUNNEL_TOKEN" ]; then
  echo "Cloudflare Tunnel mode enabled"
  LISTEN_ADDR="127.0.0.1"
  LISTEN_PORT=8080
else
  echo "Direct mode enabled"
  LISTEN_ADDR="::"
  LISTEN_PORT=${PORT}
fi

# 生成配置文件
cat > /etc/sing-box/config.json <<EOF
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
      "listen": "${LISTEN_ADDR}",
      "listen_port": ${LISTEN_PORT},
      "users": [
        {
          "uuid": "${UUID}",
          "flow": ""
        }
      ],
      "tls": {
        "enabled": false
      },
      "transport": {
        "type": "ws",
        "path": "${WS_PATH}",
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

echo "Generated config with UUID: ${UUID}, WS_PATH: ${WS_PATH}, Listen: ${LISTEN_ADDR}:${LISTEN_PORT}"

# 启动 sing-box
sing-box run -C /etc/sing-box &

# 如果启用了 Cloudflare Tunnel，启动 cloudflared
if [ -n "$CLOUDFLARE_TUNNEL_TOKEN" ]; then
  echo "Starting cloudflared tunnel..."
  exec cloudflared tunnel --no-autoupdate run --token ${CLOUDFLARE_TUNNEL_TOKEN}
else
  wait
fi
