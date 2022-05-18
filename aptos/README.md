# Aptos validator setup for Testnet

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
The default username is `aptosbot`,
replace `YOUR_IP` to your actual server IP and execute the script.
```
chmod +x aptos.sh && ./aptos.sh YOUR_IP
```

## Others


### Success recap
To recap, in your `$WORKSPACE` directory,
```
cd ~/testnet && ll
```
you should see a list of files:

- `validator.yaml` validator config file
- `fullnode.yaml` fullnode config file
- `private-keys.yaml` Private keys for owner account, consensus, networking
- `validator-identity.yaml` Private keys for setting validator identity
- `validator-full-node-identity.yaml` Private keys for setting validator full node identity
- `aptosbot.yaml` Node info for both validator / fullnode
- `layout.yaml` layout file to define root key, validator user, and chain ID
- `framework` folder which contains all the move bytecode for AptosFramework.
- `waypoint.txt` waypoint for genesis transaction
- `genesis.blob` genesis binary contains all the info about framework, validatorSet and more.

### Useful commands
Check validator running log
```
cd ~/testnet && tail -200f output.log
```

### Useful links:
- [Run a validator node](https://aptos.dev/tutorials/validator-node/intro)
- [Aptos Network Dashboard](https://status.devnet.aptos.dev/)
- [Aptos Node Checker](http://node-tools.net/aptos/tester/)
- [Testnet Intro](https://medium.com/aptoslabs/aptos-incentivized-testnet-update-abcfcd94d54c) 
- [AIT1 Intro](https://medium.com/aptoslabs/launch-of-aptos-incentivized-testnet-registration-2e85696a62d0)