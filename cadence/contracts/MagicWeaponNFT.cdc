import NonFungibleToken from "./utility/NonFungibleToken.cdc"
import MetadataViews from "./utility/MetadataViews.cdc"

pub contract MagicWeaponNFT : NonFungibleToken {
    
    // Counter the track total circulating supply
    pub var totalSupply: UInt64

    access(contract) var idCount: UInt64

    pub var arcaneTypes: [ArcaneTypeData]

    pub var arcaneGenerator: Int

    // Collection related paths
    pub let CollectionStoragePath: StoragePath
    pub let CollectionPublicPath: PublicPath
    // Admin related paths
    pub let AdminStoragePath: StoragePath

    // Events
    pub event ContractInitialized()
    pub event Withdraw(id: UInt64, from: Address?)
    pub event Deposit(id: UInt64, to: Address?)

    pub event MintedNFT(id: UInt64)
    pub event Upgraded(id: UInt64, exp: UFix64, owner: Address?)
    pub event NewArcaneTypeAdded(name: String, description: String, thumbnail: String)

    pub struct ArcaneTypeData {
        
        pub let name: String
        pub let description: String
        pub let thumbnail: String

        init(name: String, description: String, thumbnail: String) {
            self.name = name
            self.description = description
            self.thumbnail = thumbnail
        }
    }

    pub resource NFT : NonFungibleToken.INFT, MetadataViews.Resolver {

        // The unique ID that differentiates each NFT
        pub let id: UInt64

        pub let arcaneType: MagicWeaponNFT.ArcaneTypeData

        pub var exp: UFix64

        init() {
            self.id = MagicWeaponNFT.idCount
            self.arcaneType = MagicWeaponNFT.arcaneTypes[MagicWeaponNFT.arcaneGenerator % MagicWeaponNFT.arcaneTypes.length]
            MagicWeaponNFT.arcaneGenerator = MagicWeaponNFT.arcaneGenerator + 1
            self.exp = 0.0

            MagicWeaponNFT.idCount = MagicWeaponNFT.idCount + 1
            MagicWeaponNFT.totalSupply = MagicWeaponNFT.totalSupply + 1
        }

        pub fun upgrade(amount: UFix64) {
            pre {
                amount > 0.0: "Exp amount added to the weapon must be greater than zero"
            }
            self.exp = self.exp + amount
            emit Upgraded(id: self.id, exp: self.exp, owner: self.owner?.address)
        }

        pub fun getViews(): [Type] {
            return [Type<MetadataViews.Display>(), Type<String>()]
        }

        pub fun resolveView(_ view: Type): AnyStruct? {
            switch view {
                case Type<MetadataViews.Display>():
                    let file = MetadataViews.HTTPFile(self.arcaneType.thumbnail)
                    return MetadataViews.Display(name: self.arcaneType.name, description: self.arcaneType.description, thumbnail: file)
            }
            return nil
        }

        destroy() {
            MagicWeaponNFT.totalSupply = MagicWeaponNFT.totalSupply - 1
        }
    }

    pub resource interface MagicWeaponNFTCollectionPublic {
        pub fun deposit(token: @NonFungibleToken.NFT)
        pub fun getIDs(): [UInt64]
        pub fun borrowNFT(id: UInt64): &NonFungibleToken.NFT
        pub fun borrowMagicWeaponNFT(id: UInt64): &MagicWeaponNFT.NFT? {
            post {
                (result == nil) || (result?.id == id):
                    "Cannot borrow ExampleNFT reference: the ID of the returned reference is incorrect"
            }
        }
    }

    pub resource Collection : NonFungibleToken.Provider, NonFungibleToken.Receiver, NonFungibleToken.CollectionPublic, MagicWeaponNFTCollectionPublic, MetadataViews.ResolverCollection {

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

        pub fun borrowMagicWeaponNFT(id: UInt64): &MagicWeaponNFT.NFT? {
            if self.ownedNFTs[id] != nil {
                // Create an authorized reference to allow downcasting
                let ref = (&self.ownedNFTs[id] as auth &NonFungibleToken.NFT?)!
                return ref as! &MagicWeaponNFT.NFT
            }

            return nil
        }

        pub fun borrowNFTSafe(id: UInt64): &NonFungibleToken.NFT? {
            if let nftRef: &NonFungibleToken.NFT = &self.ownedNFTs[id] as &NonFungibleToken.NFT? {
                return nftRef
            }
            return nil
        }

        pub fun borrowViewResolver(id: UInt64): &AnyResource{MetadataViews.Resolver} {
            let nft = (&self.ownedNFTs[id] as auth &NonFungibleToken.NFT?)!
            let magicWeaponNFT = nft as! &MagicWeaponNFT.NFT
            return magicWeaponNFT
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
        let newNFT <- create NFT()
        emit MintedNFT(id: newNFT.id)
        return <- newNFT
    }

    pub resource Administrator {

        pub fun AddNewArcaneType(name: String, description: String, thumbnail: String) {
            let newArcane = MagicWeaponNFT.ArcaneTypeData(name: name, description: description, thumbnail: thumbnail)
            MagicWeaponNFT.arcaneTypes.append(newArcane)
            emit NewArcaneTypeAdded(name: newArcane.name, description: newArcane.description, thumbnail: newArcane.thumbnail)
        }
    }

    init() {
        self.totalSupply = 0
        self.arcaneGenerator = 0
        self.idCount = 1
        let mysticArt = MagicWeaponNFT.ArcaneTypeData(name: "Mystic Art", description: "111", thumbnail: "aaa")
        let thunder = MagicWeaponNFT.ArcaneTypeData(name: "Thunder", description: "222", thumbnail: "bbb")
        let arcaneEnergy = MagicWeaponNFT.ArcaneTypeData(name: "Arcane Energy", description: "333", thumbnail: "ccc")
        let typo = MagicWeaponNFT.ArcaneTypeData(name: "Typo", description: "444", thumbnail: "ddd")
        let aceFire = MagicWeaponNFT.ArcaneTypeData(name: "Ace Fire", description: "555", thumbnail: "eee")
        let wind = MagicWeaponNFT.ArcaneTypeData(name: "Wind", description: "666", thumbnail: "fff")
        let bathToy = MagicWeaponNFT.ArcaneTypeData(name: "Bath Toy", description: "777", thumbnail: "ggg")
        let electric = MagicWeaponNFT.ArcaneTypeData(name: "Electric", description: "888", thumbnail: "hhh")
        let water = MagicWeaponNFT.ArcaneTypeData(name: "Water", description: "999", thumbnail: "iii")
        let timeStone = MagicWeaponNFT.ArcaneTypeData(name: "Time Stone", description: "AAA", thumbnail: "jjj")
        self.arcaneTypes = [mysticArt, thunder, arcaneEnergy, typo, aceFire, wind, bathToy, electric, water, timeStone]

        self.CollectionStoragePath = /storage/MagicWeaponNFTCollection
        self.CollectionPublicPath = /public/MagicWeaponNFTCollection
        self.AdminStoragePath = /storage/MagicWeaponNFTAdmin

        self.account.save(<-self.createEmptyCollection(), to: self.CollectionStoragePath)
        self.account.link<&MagicWeaponNFT.Collection{NonFungibleToken.CollectionPublic, MagicWeaponNFT.MagicWeaponNFTCollectionPublic, MetadataViews.ResolverCollection}>(self.CollectionPublicPath, target: self.CollectionStoragePath)
    
        self.account.save(<-create self.Administrator(), to: self.AdminStoragePath)
    }
}