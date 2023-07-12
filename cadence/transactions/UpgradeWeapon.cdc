import NonFungibleToken from "../contracts/utility/NonFungibleToken.cdc"
import MagicWeaponNFT from "../contracts/MagicWeaponNFT.cdc"

transaction {

    prepare(acct: AuthAccount) {

        let collection: @NonFungibleToken.Collection <- acct.load<@MagicWeaponNFT.Collection>(from: /storage/MagicWeaponNFTCollection)!      
        let weapon <- collection.withdraw(withdrawID: 1) as! @MagicWeaponNFT.NFT
        weapon.upgrade(amount: 99.9)
        collection.deposit(token: <-weapon)
        acct.save(<-collection, to: /storage/MagicWeaponNFTCollection)
    }
}