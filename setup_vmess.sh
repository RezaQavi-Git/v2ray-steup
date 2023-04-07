#!/bin/sh

echo "GENERATE RANDOM UUID"
uuid=$(uuidgen)

echo "GENERATE VMESS CONFIG FILE"
mkdir -p /root/configs
jq --arg uuid "$uuid" --arg port "$1" '.inbounds[0].settings.clients[0].id = $uuid | .inbounds[0].port = $port'  ./configs/vmess.json > /root/configs/"vmess_$1_config".json

echo "DOCKER RUN COMMAND"
docker run -d --restart always --log-driver=none --network host -e V2RAY_VMESS_AEAD_FORCED=false -v /root/configs/"vmess_$1_config".json:/etc/v2ray/config.json:ro v2fly/v2fly-core run -config /etc/v2ray/config.json

echo "DEFAULT YOU WILL NEED"
echo address = {YOUR SERVER IP ADDRESS}
echo port = $1
echo uuid = $uuid
echo path = '/cookie'
