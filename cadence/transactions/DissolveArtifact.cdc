import FungibleToken from "../contracts/utility/FungibleToken.cdc"
import NonFungibleToken from "../contracts/utility/NonFungibleToken.cdc"
import MagicArtifactNFT from "../contracts/MagicArtifactNFT.cdc"
import ManaToken from "../contracts/ManaToken.cdc"

transaction {

    prepare(acct: AuthAccount) {
        let collection: @NonFungibleToken.Collection <- acct.load<@MagicArtifactNFT.Collection>(from: /storage/MagicArtifactNFTCollection)!      
        let artifact <- collection.withdraw(withdrawID: 1) as! @MagicArtifactNFT.NFT

        let tempVault <- ManaToken.dissolve(artifact: <-artifact)

        let vault = acct.getCapability<&{FungibleToken.Receiver}>(/public/ManaTokenReceiver).borrow() ?? panic("Failed to borrow receiver reference")
        vault.deposit(from: <-tempVault)

        acct.save(<-collection, to: /storage/MagicArtifactNFTCollection)
    }
}