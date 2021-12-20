# Pontem Bootstrap
> ***IMPORTANT: If you are using an Apple computer on the M1 chip or any other non x86_64 architecture (like the Raspberry Pi and others), you need to use the source build. In the `.env` file specify `DOCKERFILE=source.Dockerfile` instead of `DOCKERFILE=Dockerfile`. You need at least 16gb of RAM for the build!***
## Step 1: Install docker and docker-compose
For this option to work you'll need [Docker](https://docs.docker.com/engine/install/) (v18.06.0+) and [docker-compose](https://docs.docker.com/compose/install/) (v1.29+).

## Step 2: Clone this repo
```sh
git clone https://github.com/pontem-network/bootstrap.git pontem-bootstrap
cd pontem-bootstrap
```

## Step 3 - Set environment in .env
Application uses *.env* file as config.  

If to testnet, then you need `.env.testnet`:
```sh
cp .env.testnet .env
```
You can customize it, but for the first run it's not that important.
```sh
nano .env # or vi .env # or any editor you choose
```

## Step 4: Generate keys
*Note: If you want to build image from the source, uncomment the ```build``` section.*

The first thing to do is pull the docker container:
```sh
docker-compose pull
```
Now you need to generate an mnemonic phrase for your account (if you don't have one):
```sh
# Important!!!
# You need to save the output of this command.
# Do not give this data to anyone!
docker-compose run pontem-node pontem key generate --scheme sr25519
```
Add Nimbus key:
```sh
# Replace <you_mnemonic> with your mnemonic phrase.
docker-compose run pontem-node pontem key insert --suri "<you_mnemonic>" --keystore-path /opt/pontem/keys --key-type nmbs
```

## Step 5: Become collator

**Ignore this step if you just want to launch node and don't want to become collator**

Get your public key:
```sh
# Replace <you_mnemonic> with your mnemonic phrase.
docker-compose run pontem-node pontem key inspect --keystore-path /opt/pontem/keys "<you_mnemonic>"
```
***Now you need to navigate to [Pontem Docs](https://docs.pontem.network/03.-staking/collator) and follow all the steps given there.***

## Step 6: Launch node
Run node:
_Note: the collator will start its work in the next round, each round lasts `300` blocks._
```sh
docker-compose up -d
```

Show logs:
```sh
docker-compose logs -f --tail 10
```

Stop node:
```sh
docker-compose down
```

If you need additional node configuration, you can add additional arguments to the `docker-compose.yml` file in the `command` line.
To view all parameters of a node:
```sh
docker-compose run pontem-node pontem --help
```
## Optional: Monitoring
You can also easily add monitoring to your node (grafana + prometheus):
```
docker-compose -f monitoring.docker-compose.yml up -d
```
After that open `<your-server-ip>:3000` in browser. Login and password `admin`

## Documentation
See [Move VM Pallet documentation](https://docs.pontem.network/02.-getting-started/getting_started).
