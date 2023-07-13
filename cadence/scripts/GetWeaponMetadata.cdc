import MetadataViews from 0xf8d6e0586b0a20c7

pub fun main() {
    let acct = getAccount(0xf8d6e0586b0a20c7)
    let collection = acct.getCapability<&AnyResource{MetadataViews.ResolverCollection}>(/public/MagicWeaponNFTCollection).borrow() ?? panic("Cannot find resolver collection")

    let nft = collection.borrowViewResolver(id: 1)
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