module suicraft::coin {
    // use std::debug;
    // use sui::url::{Self};
    // use std::string;
    // use sui::object::{Self, UID};
    use std::option;
    use sui::coin;
    use sui::transfer;
    use sui::tx_context::{Self, TxContext};

    struct COIN has drop {}

    fun init(otw: COIN, ctx: &mut TxContext) {
        let (treasury_cap, deny_cap, meta_data) = coin::create_regulated_currency(
            otw,
            2,
            b"Symbol",
            b"Name",
            b"Description",
            // option::some(url::new_unsafe_from_bytes(b"https://suicraft.xyz/images/tokens/abc/logo.png")),
            option::none(),
            ctx
        );

        let sender = tx_context::sender(ctx);

        transfer::public_transfer(treasury_cap, sender);
        transfer::public_transfer(deny_cap, sender);
        transfer::public_transfer(meta_data, sender);
    }

    public fun mint(
        treasury_cap: &mut coin::TreasuryCap<suicraft::coin::COIN>,
        amount: u64,
        recipient: address,
        ctx: &mut TxContext,
    ) {
        let coin = coin::mint(treasury_cap, amount, ctx);
        transfer::public_transfer(coin, recipient)
    }

}