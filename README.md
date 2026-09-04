# 🛡️ ScamShield Registry

A decentralized, community-driven registry for flagging and tracking suspicious wallet addresses — built as a submission for **ONE HACK: 8-Hour AI × Web3 Hackathon** by Hackers Cult.

## The Problem

Scam and phishing wallet addresses proliferate across Web3, but there is no shared, tamper-proof, permissionless way for the community to flag them. Centralized blocklists are opaque, slow to update, and controlled by a single party. ScamShield fixes this by putting the reporting and voting process directly on-chain.

## How It Works

1. **File a Report** — Anyone can submit a report against a suspicious wallet address, including a reason and optional evidence link.
2. **Community Voting** — Anyone can upvote (confirm) or downvote (dispute) an existing report. Each wallet can vote once per report.
3. **Trust Score** — The contract aggregates all report scores for an address into a single on-chain trust score, queryable by anyone (wallets, dApps, exchanges) before interacting with that address.

## Tech Stack

- **Smart Contract:** Solidity `^0.8.20`
- **Frontend:** Vanilla HTML/CSS/JS + [ethers.js v6](https://docs.ethers.org/v6/)
- **Wallet:** MetaMask
- **Network:** Polygon Amoy Testnet (fast, free test MATIC)

## Project Structure

```
scamshield-registry/
├── contracts/
│   └── ScamRegistry.sol   # Core smart contract
├── frontend/
│   └── index.html         # Standalone dApp UI
└── README.md
```

## Deployment (Remix + Polygon Amoy)

1. Open [Remix IDE](https://remix.ethereum.org).
2. Create a new file `ScamRegistry.sol` and paste the contract code.
3. Compile with Solidity compiler `0.8.20`.
4. In the "Deploy & Run Transactions" tab, set environment to **Injected Provider - MetaMask**.
5. Switch MetaMask to **Polygon Amoy Testnet** (get free test MATIC from the [Polygon faucet](https://faucet.polygon.technology/)).
6. Deploy the contract and copy the deployed address.
7. Open `frontend/index.html`, replace `CONTRACT_ADDRESS` with your deployed address.
8. Open `index.html` in a browser (or serve locally), connect MetaMask, and interact with the registry.

## Future Scope

- IPFS-based evidence storage instead of raw links
- Reputation-weighted voting (based on wallet age / activity) to resist Sybil attacks
- Integration with an off-chain AI classifier to pre-screen and auto-flag suspicious addresses before human review
- Subgraph indexing for fast historical queries

## Team

Built by Team [YOUR TEAM NAME] for ONE HACK 2026.

## License

MIT
