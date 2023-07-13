import NonFungibleToken from "../contracts/utility/NonFungibleToken.cdc"

pub fun main() {
    let acct = getAccount(0xf8d6e0586b0a20c7)
    let collectionRef = acct.getCapability<&AnyResource{NonFungibleToken.CollectionPublic}>(/public/MagicWeaponNFTCollection).borrow() ?? panic("Cannot find collection ref")

    log("IDs")
    log(collectionRef.getIDs())
}