# SuiCraft Smart Contracts

This project contains the Sui Move smart contracts used in the service of [SuiCraft](https://suicraft.xyz).

[SuiCraft](https://suicraft.xyz) helps users to issue tokens, mint NFTs, and run DAOs on the Sui blockchain with ease, eliminating the need for coding skills or command-line experience.

## Move Projects

### coin

The coin module in suicraft_user package will be published under the names of users who wish to issue their own fungible tokens.

### registry

The registry module in suicraft_service package emits events to track user key activities, such as issuing tokens, minting NFTs, or creating DAOs.

## Deployment

1. Suicraft team publishes suicraft_service and gets its package-id.
2. Users publish coin module depending on suicraft_service::registry from suicraft website.

## 📄 License

[MIT License](https://github.com/SuiCraftTeam/Sui-dApp-Kit-Vue/blob/master/LICENSE) © 2024-PRESENT [SuiCraftTeam](https://github.com/SuiCraftTeam)