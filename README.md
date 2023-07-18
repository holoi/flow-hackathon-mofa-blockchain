# MOFA Flow Hackathon Project

This repository contains the smart contracts for the MOFA Flow hackathon project, specifically the `MagicArtifactNFT` and `ManaToken` contracts.

`MagicArtifactNFT` represents a unique, upgradeable Non-Fungible Token (NFT) that players can use within the game. The higher the level of the `MagicArtifactNFT`, the more potent it becomes, providing players with enhanced abilities.

Conversely, `ManaToken` serves as a fungible token within the game universe. The functionality it provides is uniquely tied to the `MagicArtifactNFT`:

- **Dissolution**: Players have the option to dissolve their `MagicArtifactNFT`. The outcome of this action is the acquisition of `ManaToken`s. Importantly, the quantity of `ManaToken`s received correlates directly to the level of the `MagicArtifactNFT` – the higher the level, the more `ManaToken`s a player receives.

- **Enchantment**: Players also have the opportunity to enhance the power of their `MagicArtifactNFT` by enchanting it with existing `ManaToken`s. This process further strengthens the `MagicArtifactNFT`, making it a more powerful tool within the game.

This dual-contract system forms the backbone of our game's economy, driving strategic decisions for players and enhancing the gameplay experience.

## Block Explorer and Contracts

- [Verify on Flow Testnet](https://testnet.flowscan.org/account/0x9f0cd65096757818)
- [Verify testnet deployment on Flow-view-source](https://flow-view-source.com/testnet/account/0x9f0cd65096757818)
