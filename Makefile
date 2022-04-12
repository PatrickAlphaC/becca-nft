-include .env

all: clean remove install update solc build dappbuild

# Install proper solc version.
solc:; nix-env -f https://github.com/dapphub/dapptools/archive/master.tar.gz -iA solc-static-versions.solc_0_8_11

clean:; forge clean

# Remove modules
remove :; rm -rf .gitmodules && rm -rf .git/modules/* && rm -rf lib && touch .gitmodules && git add . && git commit -m "modules"

install :; forge install dapphub/ds-test && forge install OpenZeppelin/openzeppelin-contracts && forge install brockelmore/forge-std && forge install Brechtpd/base64

# Update Dependencies
update:; forge update

build  :; forge clean && forge build --optimize --optimize-runs 1000000

test   :; forge clean && forge test --optimize --optimize-runs 1000000 -v 

# Lints
format :; yarn prettier --write src/**/*.sol && prettier --write src/*.sol

# Deploy - remember to append '0x' to your private key
deploy-rinkeby:; forge create ./src/BeccaNFT.sol:BeccaNFT -i --rpc-url ${RINKEBY_RPC_URL}
deploy-mainnet:; forge create ./src/BeccaNFT.sol:BeccaNFT -i --rpc-url ${MAINNET_RPC_URL}

# Verify
verify:; forge verify-contract --chain-id 1 --compiler-version v0.8.7+commit.e28d00a7 0xe41b658481db72b02089bc514d18207a14aefbc5 src/BeccaNFT.sol:BeccaNFT $ETHERSCAN_TOKEN