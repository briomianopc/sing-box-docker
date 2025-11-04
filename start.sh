#!/bin/sh

PORT=8080

cat <<EOF > /etc/sing-box/config.json

EOF

sing-box run -C /etc/sing-box/config.json
