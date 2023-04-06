#!/bin/sh

echo "INSTALLING DOCKER"
sudo apt-get -y update 
apt-get install -y ca-certificates curl gnupg lsb-release 
mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg -y
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update -y
apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
sudo docker run hello-world

echo "INSTALLING NECESSARY APT"
apt install -y jq nano uuidgen

echo "GENERATE RANDOM UUID"
uuid=$(uuidgen)

echo "GENERATE VMESS CONFIG FILE"
jq --arg uuid "$uuid" '.inbounds[0].settings.clients[0].id = $uuid' /configs/vmess.json > /root/vmess_config.json

echo "DOCKER RUN COMMAND"
docker run -d --restart always --log-driver=none --network host -e V2RAY_VMESS_AEAD_FORCED=false -v /root/vmess_config.json:/etc/v2ray/config.json:ro v2fly/v2fly-core run -config /etc/v2ray/config.json

echo "DETAIL YOU WILL NEED"
echo address = {YOUR SERVER IP ADDRESS}
echo port = 80
echo uuid = $uuid
echo path = '/cookie'