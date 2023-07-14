import NonFungibleToken from "../contracts/utility/NonFungibleToken.cdc"
import MagicArtifactNFT from "../contracts/MagicArtifactNFT.cdc"

pub fun main() {
    let acct = getAccount(0xf8d6e0586b0a20c7)
    let collectionRef: &AnyResource{MagicArtifactNFT.MagicArtifactNFTCollectionPublic} = acct.getCapability<&AnyResource{MagicArtifactNFT.MagicArtifactNFTCollectionPublic}>(/public/MagicArtifactNFTCollection).borrow() ?? panic("Cannot find collection ref")
    
    let weapon = collectionRef.borrowMagicArtifactNFT(id: 1)!
    log("Weapon exp")
    log(weapon.exp)

    log("Weapon name")
    log(weapon.arcaneType.name)
    log("Weapon description")
    log(weapon.arcaneType.description)
    log("Weapon thumbnail")
    log(weapon.arcaneType.thumbnail)
}