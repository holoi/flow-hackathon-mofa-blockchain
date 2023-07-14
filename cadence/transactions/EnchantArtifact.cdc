import FungibleToken from "../contracts/utility/FungibleToken.cdc"
import NonFungibleToken from "../contracts/utility/NonFungibleToken.cdc"
import MagicArtifactNFT from "../contracts/MagicArtifactNFT.cdc"
import ManaToken from "../contracts/ManaToken.cdc"

transaction {

    prepare(acct: AuthAccount) {
        
        let collectionRef: &AnyResource{MagicArtifactNFT.MagicArtifactNFTCollectionPublic} = acct.getCapability<&AnyResource{MagicArtifactNFT.MagicArtifactNFTCollectionPublic}>(/public/MagicArtifactNFTCollection).borrow() ?? panic("Cannot find collection ref")
        let artifact = collectionRef.borrowMagicArtifactNFT(id: 2)!
        
        //let vault: &AnyResource{FungibleToken.Provider} = acct.getCapability<&{FungibleToken.Provider}>(/private/ManaTokenProvider).borrow() ?? panic("Failed to borrow provider reference")
        let vault <- acct.load<@ManaToken.Vault>(from: /storage/ManaTokenVault)!
        let tempVault <- vault.withdraw(amount: 99.0) as! @ManaToken.Vault
        ManaToken.enchant(artifact: artifact, vault: <-tempVault)
        acct.save(<-vault, to: /storage/ManaTokenVault)
    }
}