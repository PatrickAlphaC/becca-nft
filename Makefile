-include .env

all: clean remove install update solc build dappbuild

# Install proper solc version.
solc:; nix-env -f https://github.com/dapphub/dapptools/archive/master.tar.gz -iA solc-static-versions.solc_0_8_11

clean:; forge clean

# Remove modules
remove :; rm -rf .gitmodules && rm -rf .git/modules/* && rm -rf lib && touch .gitmodules && git add . && git commit -m "modules"

install :; forge install dapphub/ds-test && forge install OpenZeppelin/openzeppelin-contracts && forge install brockelmore/forge-std 

# Update Dependencies
update:; forge update

build  :; forge clean && forge build --optimize --optimize-runs 1000000

test   :; forge clean && forge test --optimize --optimize-runs 1000000 -v 

# Lints
format :; yarn prettier --write src/**/*.sol && prettier --write src/*.sol

# Deploy rinkeby
deploy-rinkeby:; forge create ./src/BeccaNFT.sol:BeccaNFT -i --rpc-url $RINKEBY_RPC_URL 