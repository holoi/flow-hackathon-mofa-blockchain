//import FungibleToken from 0x9f0cd65096757818
//import NonFungibleToken from 0x9f0cd65096757818
// import MagicArtifactNFT from 0x9f0cd65096757818

import NonFungibleToken from "../contracts/utility/NonFungibleToken.cdc"
import MagicArtifactNFT from "../contracts/MagicArtifactNFT.cdc"

pub fun main() {

    let acct = getAccount(0xf8d6e0586b0a20c7)
    let collectionRef = acct.getCapability<&AnyResource{NonFungibleToken.CollectionPublic}>(/public/MagicArtifactNFTCollection).borrow() ?? panic("Cannot find collection ref")

    log("---------------------------------------")
    log("IDs")
    log(collectionRef.getIDs())

    let collectionRef2: &AnyResource{MagicArtifactNFT.MagicArtifactNFTCollectionPublic} = acct.getCapability<&AnyResource{MagicArtifactNFT.MagicArtifactNFTCollectionPublic}>(/public/MagicArtifactNFTCollection).borrow() ?? panic("Cannot find collection ref")
    // var artifact = collectionRef2.borrowMagicArtifactNFT(id: 1)!
    // log("ID: 1")
    // log("Artifact name")
    // log(artifact.arcaneType.name)
    // log("Artifact description")
    // log(artifact.arcaneType.description)
    // log("Artifact thumbnail")
    // log(artifact.arcaneType.thumbnail)
    // log("Artifact exp")
    // log(artifact.exp)
    // log("++++++")

    var artifact = collectionRef2.borrowMagicArtifactNFT(id: 2)!
    log("ID: 2")
    log("Artifact name")
    log(artifact.arcaneType.name)
    log("Artifact description")
    log(artifact.arcaneType.description)
    log("Artifact thumbnail")
    log(artifact.arcaneType.thumbnail)
    log("Artifact exp")
    log(artifact.exp)
    log("++++++")

    artifact = collectionRef2.borrowMagicArtifactNFT(id: 3)!
    log("ID: 3")
    log("Artifact name")
    log(artifact.arcaneType.name)
    log("Artifact description")
    log(artifact.arcaneType.description)
    log("Artifact thumbnail")
    log(artifact.arcaneType.thumbnail)
    log("Artifact exp")
    log(artifact.exp)
    log("++++++")

    artifact = collectionRef2.borrowMagicArtifactNFT(id: 4)!
    log("ID: 4")
    log("Artifact name")
    log(artifact.arcaneType.name)
    log("Artifact description")
    log(artifact.arcaneType.description)
    log("Artifact thumbnail")
    log(artifact.arcaneType.thumbnail)
    log("Artifact exp")
    log(artifact.exp)
    log("++++++")

    artifact = collectionRef2.borrowMagicArtifactNFT(id: 5)!
    log("ID: 5")
    log("Artifact name")
    log(artifact.arcaneType.name)
    log("Artifact description")
    log(artifact.arcaneType.description)
    log("Artifact thumbnail")
    log(artifact.arcaneType.thumbnail)
    log("Artifact exp")
    log(artifact.exp)
    log("++++++")
}