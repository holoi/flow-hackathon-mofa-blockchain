import NonFungibleToken from "../contracts/utility/NonFungibleToken.cdc"
import MagicArtifactNFT from "../contracts/MagicArtifactNFT.cdc"

transaction {

    prepare(acct: AuthAccount) {
        
        let collectionCap = acct.getCapability<&AnyResource{NonFungibleToken.CollectionPublic}>(/public/MagicArtifactNFTCollection)
        let collectionRef = collectionCap.borrow() ?? panic("Could not borrow reference to the collection")

        let artifactNFT <- MagicArtifactNFT.mintNFT()
        let id = artifactNFT.id
        collectionRef.deposit(token: <-artifactNFT)

        log("Magic Artifact minted with ID:")
        log(id)
    }
}
