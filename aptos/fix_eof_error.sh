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

echo "\e[1m\e[32m当遇到 Unexpected error: EOF while parsing a value 错误，可执行这个脚本修复... \e[0m" && sleep 1

export WORKSPACE=testnet

echo "\e[1m\e[32m1. 再次创建 layout / validator yaml，构建和编译... \e[0m" && sleep 1

cd ~/$WORKSPACE
rm layout.yaml
rm validator.yaml

touch ~/$WORKSPACE/layout.yaml
touch ~/$WORKSPACE/validator.yaml

echo '
---
root_key: "0x5243ca72b0766d9e9cbf2debf6153443b01a1e0e6d086c7ea206eaf6f8043956"
users:
  - aptosbot
chain_id: 23
' >> ./layout.yaml

cd ~/aptos-core
cargo run --release -p aptos -- genesis generate-genesis --local-repository-dir ~/$WORKSPACE --output-dir ~/$WORKSPACE

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

echo "\e[1m\e[32m2. 重新启动本地验证器，即将全部完成... \e[0m" && sleep 1
cd ~/aptos-core
nohup cargo run -p aptos-node --release -- -f ~/$WORKSPACE/validator.yaml  >> ~/$WORKSPACE/output.log 2>&1 &