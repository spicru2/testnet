# Aptos validator setup for Testnet
Official documents:
> [Run a validator node](https://aptos.dev/tutorials/validator-node/intro)
Usefull tools:
> To find latest block height use [Aptos Network Dashboard](https://status.devnet.aptos.dev/)\
> To check your node health status try [Aptos Node Informer](http://node-tools.net/aptos/tester/)
## Hardware requirements:
#### For running an aptos node on incentivized testnet we recommend the following:
- CPU: 4 cores (Intel Xeon Skylake or newer)
- Memory: 8GiB RAM
- Disk: 300 GB

## Set up your aptos validator
### Automatic Script
Use script below for a quick installation, replace `YOUR_IP` to your server IP.
```
wget -qO aptos.sh https://raw.githubusercontent.com/spicru2/testnet/main/aptos/aptos.sh && chmod +x aptos.sh && ./aptos.sh aptosbot YOUR_IP 
```