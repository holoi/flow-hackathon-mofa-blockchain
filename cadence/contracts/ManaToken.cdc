import FungibleToken from "./utility/FungibleToken.cdc"
import MagicArtifactNFT from "./MagicArtifactNFT.cdc"
import ManaTokenInterface from "./ManaTokenInterface.cdc"

pub contract ManaToken : FungibleToken {

    // Total supply of ManaToken in existence
    pub var totalSupply: UFix64

    pub let VaultStoragePath: StoragePath
    pub let ReceiverPublicPath: PublicPath
    pub let BalancePublicPath: PublicPath
    pub let ProviderPrivatePath: PrivatePath

    // The event that is emitted when the contract is created
    pub event TokensInitialized(initialSupply: UFix64)

    // The event that is emitted when tokens are withdrawn from a vault
    pub event TokensWithdrawn(amount: UFix64, from: Address?)

    // The event that is emitted when tokens are deposited to a vault
    pub event TokensDeposited(amount: UFix64, to: Address?)

    // The event that is emitted when new tokens are minted
    pub event TokensMinted(amount: UFix64)

    // The event that is emitted when tokens are destroyed
    pub event TokensBurned(amount: UFix64)

    pub resource Vault: FungibleToken.Provider, FungibleToken.Receiver, FungibleToken.Balance, ManaTokenInterface.IVault {

        // The total balance of this vault
        pub var balance: UFix64

        init(balance: UFix64) {
            self.balance = balance
        }

        pub fun withdraw(amount: UFix64): @FungibleToken.Vault {
            self.balance = self.balance - amount
            emit TokensWithdrawn(amount: amount, from: self.owner?.address)
            return <- create Vault(balance: amount)
        }

        pub fun deposit(from: @FungibleToken.Vault) {
            let vault <- from as! @ManaToken.Vault
            self.balance = self.balance + vault.balance
            emit TokensDeposited(amount: vault.balance, to: self.owner?.address)
            vault.balance = 0.0
            destroy vault
        }

        pub fun clearBalance() {
            self.balance = 0.0
        }

        destroy() {
            if self.balance > 0.0 {
                ManaToken.totalSupply = ManaToken.totalSupply - self.balance
            }
        }
    }

    pub fun createEmptyVault(): @ManaToken.Vault {
        return <- create Vault(balance: 0.0)
    }

    // Dissolve a MagicArtifact NFT and save its exp as Mana token in a new vault
    pub fun dissolve(artifact: @MagicArtifactNFT.NFT): @FungibleToken.Vault {
        let vault <- create Vault(balance: artifact.exp)
        destroy artifact
        return <- vault
    }

    pub fun enchant(artifact: &MagicArtifactNFT.NFT, vault: @ManaToken.Vault) {
        artifact.enchant(vault: <-vault)
    }

    init() {

        self.totalSupply = 0.0

        self.VaultStoragePath = /storage/ManaTokenVault
        self.ReceiverPublicPath = /public/ManaTokenReceiver
        self.BalancePublicPath = /public/ManaTokenBalance
        self.ProviderPrivatePath = /private/ManaTokenProvider

        let vault <- create Vault(balance: self.totalSupply)
        self.account.save(<-vault, to: self.VaultStoragePath)

        self.account.link<&{FungibleToken.Receiver}>(self.ReceiverPublicPath, target: self.VaultStoragePath)
        self.account.link<&{FungibleToken.Balance}>(self.BalancePublicPath, target: self.VaultStoragePath)

        emit TokensInitialized(initialSupply: self.totalSupply)
    }
}