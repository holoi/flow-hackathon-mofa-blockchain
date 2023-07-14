//import MetadataViews from 0xf8d6e0586b0a20c7
import MetadataViews from "../contracts/utility/MetadataViews.cdc"

pub fun main() {
    let acct = getAccount(0xf8d6e0586b0a20c7)
    let collection = acct.getCapability<&AnyResource{MetadataViews.ResolverCollection}>(/public/MagicArtifactNFTCollection).borrow() ?? panic("Cannot find resolver collection")

    let nft = collection.borrowViewResolver(id: 5)
    let view = nft.resolveView(Type<MetadataViews.Display>())!
    let display = view as! MetadataViews.Display

    if (display != nil) {
        log("good")
    } else {
        log("no good")
    }

    log("name")
    log(display.name)
    log("description")
    log(display.description)
}