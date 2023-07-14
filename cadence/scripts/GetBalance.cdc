import FungibleToken from "../contracts/utility/FungibleToken.cdc"

pub fun main() {

    let acct = getAccount(0xf8d6e0586b0a20c7)
    let vaultRef = acct.getCapability<&{FungibleToken.Balance}>(/public/ManaTokenBalance).borrow() ?? panic("Failed to borrow vault reference")

    log("balance:")
    log(vaultRef.balance)
}