import NonFungibleToken from "./utility/NonFungibleToken.cdc"

pub contract MagicWeaponNFT : NonFungibleToken {
    
    // Counter the track total circulating supply
    pub var totalSupply: UInt64

    access(contract) var idCount: UInt64

    access(contract) var totalArcaneTypeCount: UInt64

    // Collection related paths
    pub let CollectionStoragePath: StoragePath
    pub let CollectionPublicPath: PublicPath

    // Events
    pub event ContractInitialized()
    pub event Withdraw(id: UInt64, from: Address?)
    pub event Deposit(id: UInt64, to: Address?)

    pub event MintedNFT(id: UInt64, arcaneType: UInt64)
    pub event Upgraded(id: UInt64, exp: UFix64)

    pub resource NFT : NonFungibleToken.INFT {

        // The unique ID that differentiates each NFT
        pub let id: UInt64

        pub let arcaneType: UInt64

        pub var exp: UFix64

        init(arcaneType: UInt64) {
            self.id = MagicWeaponNFT.idCount
            self.arcaneType = arcaneType
            self.exp = 0.0

            MagicWeaponNFT.idCount = MagicWeaponNFT.idCount + 1
            MagicWeaponNFT.totalSupply = MagicWeaponNFT.totalSupply + 1
        }

        pub fun upgrade(amount: UFix64) {
            pre {
                amount > 0.0: "Exp amount added to the weapon must be greater than zero"
            }
            self.exp = self.exp + amount
            emit Upgraded(id: self.id, exp: self.exp)
        }

        destroy() {
            MagicWeaponNFT.totalSupply = MagicWeaponNFT.totalSupply - 1
        }
    }

    pub resource Collection : NonFungibleToken.Provider, NonFungibleToken.Receiver, NonFungibleToken.CollectionPublic {

        pub var ownedNFTs: @{UInt64 : NonFungibleToken.NFT}

        init() {
            self.ownedNFTs <- {}
        }

        // Remove an NFT from the collection and moves it to the caller
        pub fun withdraw(withdrawID: UInt64): @NonFungibleToken.NFT {
            let token:@NonFungibleToken.NFT <- self.ownedNFTs.remove(key: withdrawID) ?? panic("missing NFT")
            emit Withdraw(id: token.id, from: self.owner?.address)
            return <- token
        }

        pub fun deposit(token: @NonFungibleToken.NFT) {
            let token <- token as! @MagicWeaponNFT.NFT
            let id: UInt64 = token.id
            let oldToken <- self.ownedNFTs[id] <- token
            emit Deposit(id: id, to: self.owner?.address)
            destroy oldToken
        }

        // Returns an array of the IDs that are in the collection
        pub fun getIDs(): [UInt64] {
            return self.ownedNFTs.keys
        }

        pub fun borrowNFT(id: UInt64): &NonFungibleToken.NFT {
            return (&self.ownedNFTs[id] as &NonFungibleToken.NFT?)!
        }

        pub fun borrowNFTSafe(id: UInt64): &NonFungibleToken.NFT? {
            if let nftRef: &NonFungibleToken.NFT = &self.ownedNFTs[id] as &NonFungibleToken.NFT? {
                return nftRef
            }
            return nil
        }

        destroy() {
            pre {
                self.ownedNFTs.length == 0: "NFTs still contained in this collection"
            }
            destroy self.ownedNFTs
        }
    }

    pub fun createEmptyCollection(): @NonFungibleToken.Collection {
        let newCollection <- create Collection() as @NonFungibleToken.Collection
        return <- newCollection
    }

    pub fun mintNFT(): @MagicWeaponNFT.NFT {
        let arcaneType = unsafeRandom() % self.totalArcaneTypeCount
        let newNFT <- create NFT(arcaneType: arcaneType)
        emit MintedNFT(id: newNFT.id, arcaneType: newNFT.arcaneType)
        return <- newNFT
    }

    init() {
        self.totalSupply = 0
        self.idCount = 1
        self.totalArcaneTypeCount = 10

        self.CollectionStoragePath = /storage/MagicWeaponNFTCollection
        self.CollectionPublicPath = /public/MagicWeaponNFTCollection

        self.account.save(<-self.createEmptyCollection(), to: self.CollectionStoragePath)
        self.account.link<&{NonFungibleToken.CollectionPublic}>(self.CollectionPublicPath, target: self.CollectionStoragePath)
    }
}