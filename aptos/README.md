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

## Set up your aptos validator with automatic script in 4 steps

#### STEP 1
Login to your server within SSH, switch to `root` user.
```
sudo su root
```

#### STEP 2
Go to `/root` directory.
```
cd ~ && pwd
```

#### STEP 3
Download the script.
```
wget -qO aptos.sh https://raw.githubusercontent.com/spicru2/testnet/main/aptos/aptos.sh 
```

#### STEP 4
replace `YOUR_IP` to your actual server IP and execute the script.
```
chmod +x aptos.sh && ./aptos.sh aptosbot YOUR_IP
```

## Useful commands
Check running log
```
cd ~/testnet && tail -200f output.log
```