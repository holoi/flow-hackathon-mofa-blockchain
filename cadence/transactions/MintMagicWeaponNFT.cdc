import NonFungibleToken from "../contracts/utility/NonFungibleToken.cdc"
import MagicWeaponNFT from "../contracts/MagicWeaponNFT.cdc"

transaction {

    prepare(acct: AuthAccount) {
        
        let collectionCap = acct.getCapability<&AnyResource{NonFungibleToken.CollectionPublic}>(/public/MagicWeaponNFTCollection)
        let collectionRef = collectionCap.borrow() ?? panic("Could not borrow reference to the collection")

        let weaponNFT <- MagicWeaponNFT.mintNFT()
        collectionRef.deposit(token: <-weaponNFT)
    }
}
