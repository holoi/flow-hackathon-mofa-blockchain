import NonFungibleToken from "../contracts/utility/NonFungibleToken.cdc"
import MagicArtifactNFT from "../contracts/MagicArtifactNFT.cdc"

transaction {

    prepare(acct: AuthAccount) {

        let collection: @NonFungibleToken.Collection <- acct.load<@MagicArtifactNFT.Collection>(from: /storage/MagicArtifactNFTCollection)!      
        let artifact <- collection.withdraw(withdrawID: 1) as! @MagicArtifactNFT.NFT
        artifact.upgrade(amount: 99.9)
        let exp = artifact.exp
        collection.deposit(token: <-artifact)
        acct.save(<-collection, to: /storage/MagicArtifactNFTCollection)

        log("Magic Artifact exp added:")
        log(exp)
    }
}