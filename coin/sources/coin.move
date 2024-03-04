module suicraft::coin {
    use std::ascii;
    use std::string;
    use std::option;
    use sui::coin;
    use sui::deny_list;
    use sui::transfer;
    use sui::tx_context::{Self, TxContext};

    struct COIN has drop {}

    fun init(otw: COIN, ctx: &mut TxContext) {
        let (treasury_cap, deny_cap, meta_data) = coin::create_regulated_currency(
            otw,
            2,
            b"$MYCOIN",
            b"My Coin",
            b"This coin is created by SuiCraft, meta data is to be updated.",
            option::none(),
            ctx
        );

        let sender = tx_context::sender(ctx);

        transfer::public_transfer(treasury_cap, sender);
        transfer::public_transfer(deny_cap, sender);
        transfer::public_transfer(meta_data, sender);
    }

    public entry fun update_name(
        treasury: &coin::TreasuryCap<suicraft::coin::COIN>,
        metadata: &mut coin::CoinMetadata<suicraft::coin::COIN>,
        name: string::String
    ) {
        coin::update_name(treasury, metadata, name);
    }

    public entry fun update_symbol(
        treasury: &coin::TreasuryCap<suicraft::coin::COIN>,
        metadata: &mut coin::CoinMetadata<suicraft::coin::COIN>,
        symbol: ascii::String
    ) {
        coin::update_symbol(treasury, metadata, symbol);
    }

    public entry fun update_description(
        treasury: &coin::TreasuryCap<suicraft::coin::COIN>,
        metadata: &mut coin::CoinMetadata<suicraft::coin::COIN>,
        description: string::String
    ) {
        coin::update_description(treasury, metadata, description);
    }

    public entry fun update_icon_url(
        treasury: &coin::TreasuryCap<suicraft::coin::COIN>,
        metadata: &mut coin::CoinMetadata<suicraft::coin::COIN>,
         url: ascii::String
    ) {
        coin::update_icon_url(treasury, metadata, url);
    }

    public entry fun add_addr_to_deny_list(
        denylist: &mut deny_list::DenyList,
        denycap: &mut coin::DenyCap<suicraft::coin::COIN>,
        denyaddy: address,
        ctx: &mut TxContext
    ) {
        // denylist is 0x403
        coin::deny_list_add(denylist, denycap, denyaddy, ctx);
    }

    public entry fun remove_addr_from_deny_list(
        denylist: &mut deny_list::DenyList,
        denycap: &mut coin::DenyCap<suicraft::coin::COIN>,
        denyaddy: address,
        ctx: &mut TxContext
    ) {
        // denylist is 0x403
        coin::deny_list_remove(denylist, denycap, denyaddy, ctx);
    }

    public entry fun mint(
        treasury_cap: &mut coin::TreasuryCap<suicraft::coin::COIN>,
        amount: u64,
        recipient: address,
        ctx: &mut TxContext,
    ) {
        let coin = coin::mint(treasury_cap, amount, ctx);
        transfer::public_transfer(coin, recipient)
    }

}