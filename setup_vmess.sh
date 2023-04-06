#!/bin/sh

echo "INSTALLING DOCKER"
sudo apt-get update -y
apt-get install ca-certificates curl gnupg lsb-release -y
mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update -y
apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y
sudo docker run hello-world

echo "INSTALLING NECESSARY APT"
apt install jq -y
apt install nano -y

echo "GENERATE RANDOM UUID"
uuid=$(uuidgen)
echo uuid=$(uuid)

echo "GENERATE VMESS CONFIG FILE"
jq --arg uuid "$uuid" '.inbounds[0].settings.clients[0].id = $uuid' /configs/vmess.json > /root/vmess_config.json

echo "DOCKER RUN COMMAND"
docker run -d --restart always --log-driver=none --network host -e V2RAY_VMESS_AEAD_FORCED=false -v /root/vmess_config.json:/etc/v2ray/config.json:ro v2fly/v2fly-core run -config /etc/v2ray/config.json