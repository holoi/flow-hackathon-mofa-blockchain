import NonFungibleToken from "../contracts/utility/NonFungibleToken.cdc"
import MagicWeaponNFT from "../contracts/MagicWeaponNFT.cdc"

pub fun main() {
    let acct = getAccount(0xf8d6e0586b0a20c7)
    let collectionRef = acct.getCapability<&AnyResource{MagicWeaponNFT.MagicWeaponNFTCollectionPublic}>(/public/MagicWeaponNFTCollection).borrow() ?? panic("Cannot find collection ref")
    
    let weapon = collectionRef.borrowMagicWeaponNFT(id: 1)!
    log("Weapon exp")
    log(weapon.exp)
}