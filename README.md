# Pipeline

This project demonstrates a CI/CD pipeline to deploy and upgrade UUPS based smart contracts. It makes use of Foundry and Safe for multi-sig approved upgrades.

The Foundry scripts allow us to maintain some cohesion between the contracts and deployment scripts. We make use of Safe to propose transactions to a specific wallet where a signer has access to.

This also makes use of Deno to run the Safe script for publishing considering there's some reliance in outside data to inform about secrets and the environment through the steps in the Github action.

The example script I provided has two contracts, one for the first time deployment and one for the subsequent upgrades. Once every run is done the changes are recorded in the `broadcast` folder where we can take the last occurrence and get all addresses that are relevant for a contract deployment.

## Example run

1. See `.env.sample` for an example environment you need for this to run.
2. Run the script

```sh
forge script --chain sepolia script/deploy/Counter.s.sol:Deployment --rpc-url $RPC_URL -vvvv --broadcast
```

3. Make changes to the `Counter.sol` contract
4. Run an upgrade

```sh
forge script --chain sepolia script/deploy/Counter.s.sol:Upgrade --rpc-url $RPC_URL -vvvv --broadcast
```

5. Source the environment with the addresses
6. Run the safe publish script

```sh
deno run --allow-read --allow-env --allow-net --allow-ffi safe-publish.ts
```

7. Approve the transaction in the Safe

The problem with running this manually rather than in a CI is that it's harder to capture transaction hashes, addresses, etc. Ideally this process is run through a Git user that has enough permissions to open new PRs where the deployment changes are present.

See the github workflow for more context about this.
