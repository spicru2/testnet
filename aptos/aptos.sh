#!/bin/sh

echo "================================================================================"
echo "#   ██████╗██████╗ ██╗   ██╗███████╗██╗  ██╗███████╗   ███████╗████████╗██╗  ██╗";
echo "#  ██╔════╝██╔══██╗██║   ██║╚══███╔╝██║  ██║██╔════╝   ██╔════╝╚══██╔══╝██║  ██║";
echo "#  ██║     ██████╔╝██║   ██║  ███╔╝ ███████║█████╗     █████╗     ██║   ███████║";
echo "#  ██║     ██╔══██╗██║   ██║ ███╔╝  ██╔══██║██╔══╝     ██╔══╝     ██║   ██╔══██║";
echo "#  ╚██████╗██║  ██║╚██████╔╝███████╗██║  ██║███████╗██╗███████╗   ██║   ██║  ██║";
echo "#   ╚═════╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝╚═╝  ╚═╝╚══════╝╚═╝╚══════╝   ╚═╝   ╚═╝  ╚═╝";
echo "================================================================================"
sleep 2

echo "\e[1m\e[32m1. 安装依赖，准备环境... \e[0m" && sleep 1
sudo apt install git
git clone https://github.com/aptos-labs/aptos-core.git
cd ~/aptos-core
./scripts/dev_setup.sh
source ~/.cargo/env
git checkout --track origin/testnet

echo "\e[1m\e[32m2. 配置网络端口... \e[0m" && sleep 1
sudo apt-get update
sudo apt-get install iptables
sudo iptables -I INPUT -p tcp --dport 8080 -j ACCEPT
sudo iptables -I INPUT -p tcp --dport 9101 -j ACCEPT
sudo iptables -I INPUT -p tcp --dport 9102 -j ACCEPT
sudo iptables -I INPUT -p tcp --dport 6180 -j ACCEPT
sudo iptables -I INPUT -p tcp --dport 6181 -j ACCEPT
sudo iptables -I INPUT -p tcp --dport 6182 -j ACCEPT
sudo iptables -I INPUT -p tcp --dport 6191 -j ACCEPT
iptables-save
sudo apt-get install iptables-persistent
sudo netfilter-persistent save
sudo netfilter-persistent reload

echo "\e[1m\e[32m3. 创建目录，生成密钥对... \e[0m" && sleep 1
export WORKSPACE=testnet
mkdir ~/$WORKSPACE
cd ~/aptos-core
cargo run --release -p aptos -- genesis generate-keys --output-dir ~/$WORKSPACE
cargo run -p aptos -- genesis set-validator-configuration \
 --keys-dir ~/$WORKSPACE --local-repository-dir ~/$WORKSPACE \
 --username $1 \
 --validator-host $2:6180 \
 --full-node-host $2:6182

echo "\e[1m\e[32m4. 创建 layout.yaml，构建和编译... \e[0m" && sleep 1
touch ~/$WORKSPACE/layout.yaml

echo '
---
root_key: "0x5243ca72b0766d9e9cbf2debf6153443b01a1e0e6d086c7ea206eaf6f8043956"
users:
  - '${1}'
chain_id: 23
' >> ./layout.yaml
cargo run --release --package framework -- --package aptos-framework --output current

mkdir ~/$WORKSPACE/framework

mv aptos-framework/releases/artifacts/current/build/**/bytecode_modules/*.mv ~/$WORKSPACE/framework/

cargo run --release -p aptos -- genesis generate-genesis --local-repository-dir ~/$WORKSPACE --output-dir ~/$WORKSPACE

echo "\e[1m\e[32m5. 创建 validator.yaml，构建和编译... \e[0m" && sleep 1

echo '
base:
  role: "validator"
  data_dir: "/root/testnet/data"
  waypoint:
    from_file: "/root/testnet/waypoint.txt"

consensus:
  safety_rules:
    service:
      type: "local"
    backend:
      type: "on_disk_storage"
      path: /root/testnet/data/secure-data.json
      namespace: ~
    initial_safety_rules_config:
      from_file:
        waypoint:
          from_file: /root/testnet/waypoint.txt
        identity_blob_path: /root/testnet/validator-identity.yaml

execution:
  genesis_file_location: "/root/testnet/genesis.blob"
  concurrency_level: 4

validator_network:
  discovery_method: "onchain"
  mutual_authentication: true
  identity:
    type: "from_file"
    path: /root/testnet/validator-identity.yaml

full_node_networks:
- network_id:
    private: "vfn"
  listen_address: "/ip4/0.0.0.0/tcp/6181"
  identity:
    type: "from_config"
    key: "b0f405a3e75516763c43a2ae1d70423699f34cd68fa9f8c6bb2d67aa87d0af69"
    peer_id: "00000000000000000000000000000000d58bc7bb154b38039bc9096ce04e1237"

api:
  enabled: true
  address: "0.0.0.0:8080"
' >> ~/$WORKSPACE/validator.yaml

echo "\e[1m\e[32m6. 启动本地验证器，即将全部完成... \e[0m" && sleep 1
nohup cargo run -p aptos-node --release -- -f ~/$WORKSPACE/validator.yaml  >> ~/$WORKSPACE/output.log 2>&1 &
