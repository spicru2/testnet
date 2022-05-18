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

echo "\e[1m\e[32m1. 再次创建 layout.yaml，构建和编译... \e[0m" && sleep 1
touch ~/$WORKSPACE/layout.yaml

echo '
---
root_key: "0x5243ca72b0766d9e9cbf2debf6153443b01a1e0e6d086c7ea206eaf6f8043956"
users:
  - aptosbot
chain_id: 23
' >> ./layout.yaml

cd ~/aptos-core
cargo run --release -p aptos -- genesis generate-genesis --local-repository-dir ~/$WORKSPACE --output-dir ~/$WORKSPACE

echo "\e[1m\e[32m2. 重新启动本地验证器，即将全部完成... \e[0m" && sleep 1
cd ~/aptos-core
nohup cargo run -p aptos-node --release -- -f ~/$WORKSPACE/validator.yaml  >> ~/$WORKSPACE/output.log 2>&1 &