# Pontem Bootstrap
## Step 1: Install docker and docker-compose
For this option to work you'll need [Docker](https://docs.docker.com/engine/install/) (v18.06.0+) and [docker-compose](https://docs.docker.com/compose/install/) (v3.7+).

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

## Step 4: Build docker and generate keys
The first thing to do is build the docker container (important note: if you change the `.env` file, you need to rebuild the container).:
```sh
docker-compose build
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

## Step 5: Connect as a new collator

Get your public key:
```sh
# Replace <you_mnemonic> with your mnemonic phrase.
docker-compose run pontem-node pontem key inspect --keystore-path /opt/pontem/keys "<you_mnemonic>"
```

You will see something like (for example):
```sh
Secret Key URI `//Bob` is account:
Secret seed:       0x02ca07977bdc4c93b5e00fcbb991b4e8ae20d05444153fd968e04bed6b4946e7
Public key (hex):  0xb832ced5ca2de9fe76ef101d8ab1b8dd778e1ab5a809d019c57b78e45ecbaa56
Public key (SS58): 5GEDm6TY5apP4bhwuTtTzA7z9vHbCL1V2D5nE8sPga6WKhNH
Account ID:        0xb832ced5ca2de9fe76ef101d8ab1b8dd778e1ab5a809d019c57b78e45ecbaa56
SS58 Address:      5GEDm6TY5apP4bhwuTtTzA7z9vHbCL1V2D5nE8sPga6WKhNH
```

Copy `Public key (hex)` as your public key, it's going to be your validator public key.
Now you need to map your public key with your account.

Send new transaction to map your public key with your account:

1. Navigate to [extrinsics](https://polkadot.js.org/apps/?rpc=wss://testnet.pontem.network/ws#/extrinsics).
2. Choose `authorMapping` pallet.
3. Choose `addAssociation(author_id)` function.
4. Put your public key in `author_id` field.
5. Send transaction from your account.

Now create your validator:

1. Navigate to [extrinsics](https://polkadot.js.org/apps/?rpc=wss://testnet.pontem.network/ws#/extrinsics).
2. Choose `parachainStaking` pallet.
3. Choose `joinCandidates(bond, candidate_count)` function.
_Note: for the collator to work, `1000 PONT` or more are required._
4. Put amount to bond in PONT tokens.
5. For candidate_count use `1`.
6. Send transaction.

Now time to launch your node.

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

If you need additional node configuration, you can add additional arguments to the `docker-compose.yml` file in the` command` line.
To view all parameters of a node:
```sh
docker-compose run pontem-node pontem --help
```

## Documentation
See [Move VM Pallet documentation](https://docs.pontem.network/02.-getting-started/getting_started).
