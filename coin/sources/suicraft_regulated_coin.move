module suicraft_user::suicraft_regulated_coin {
    use std::ascii;
    use std::string;
    use std::option;
    use sui::coin;
    use sui::deny_list;
    use sui::transfer;
    use sui::tx_context::{Self, TxContext};
    use suicraft_service::coin_issuance;

    struct SUICRAFT_REGULATED_COIN has drop {}

    fun init(otw: SUICRAFT_REGULATED_COIN, ctx: &mut TxContext) {
        let (treasury_cap, deny_cap, meta_data) = coin::create_regulated_currency(
            otw,
            9,
            b"$MYCOIN",
            b"My Coin",
            b"This coin is created by SuiCraft, meta data is to be updated.",
            option::none(),
            ctx
        );

        coin_issuance::register_coin(&treasury_cap, &deny_cap, &meta_data, ctx);

        let sender = tx_context::sender(ctx);
        transfer::public_transfer(treasury_cap, sender);
        transfer::public_transfer(deny_cap, sender);
        transfer::public_transfer(meta_data, sender);
    }

    public entry fun update_name(
        treasury: &coin::TreasuryCap<suicraft_user::suicraft_regulated_coin::SUICRAFT_REGULATED_COIN>,
        metadata: &mut coin::CoinMetadata<suicraft_user::suicraft_regulated_coin::SUICRAFT_REGULATED_COIN>,
        name: string::String
    ) {
        coin::update_name(treasury, metadata, name);
    }

    public entry fun update_symbol(
        treasury: &coin::TreasuryCap<suicraft_user::suicraft_regulated_coin::SUICRAFT_REGULATED_COIN>,
        metadata: &mut coin::CoinMetadata<suicraft_user::suicraft_regulated_coin::SUICRAFT_REGULATED_COIN>,
        symbol: ascii::String
    ) {
        coin::update_symbol(treasury, metadata, symbol);
    }

    public entry fun update_description(
        treasury: &coin::TreasuryCap<suicraft_user::suicraft_regulated_coin::SUICRAFT_REGULATED_COIN>,
        metadata: &mut coin::CoinMetadata<suicraft_user::suicraft_regulated_coin::SUICRAFT_REGULATED_COIN>,
        description: string::String
    ) {
        coin::update_description(treasury, metadata, description);
    }

    public entry fun update_icon_url(
        treasury: &coin::TreasuryCap<suicraft_user::suicraft_regulated_coin::SUICRAFT_REGULATED_COIN>,
        metadata: &mut coin::CoinMetadata<suicraft_user::suicraft_regulated_coin::SUICRAFT_REGULATED_COIN>,
        url: ascii::String
    ) {
        coin::update_icon_url(treasury, metadata, url);
    }

    public entry fun freeze_meta_data(
        metadata: coin::CoinMetadata<suicraft_user::suicraft_regulated_coin::SUICRAFT_REGULATED_COIN>
    ) {
        transfer::public_freeze_object(metadata);
    }

    public entry fun add_addr_to_deny_list(
        denylist: &mut deny_list::DenyList,
        denycap: &mut coin::DenyCap<suicraft_user::suicraft_regulated_coin::SUICRAFT_REGULATED_COIN>,
        denyaddy: address,
        ctx: &mut TxContext
    ) {
        // denylist is 0x403
        coin::deny_list_add(denylist, denycap, denyaddy, ctx);
    }

    public entry fun remove_addr_from_deny_list(
        denylist: &mut deny_list::DenyList,
        denycap: &mut coin::DenyCap<suicraft_user::suicraft_regulated_coin::SUICRAFT_REGULATED_COIN>,
        denyaddy: address,
        ctx: &mut TxContext
    ) {
        // denylist is 0x403
        coin::deny_list_remove(denylist, denycap, denyaddy, ctx);
    }

    public entry fun freeze_deny_cap(
        denycap: coin::DenyCap<suicraft_user::suicraft_regulated_coin::SUICRAFT_REGULATED_COIN>,
    ) {
        transfer::public_freeze_object(denycap);
    }

    public entry fun mint(
        treasury_cap: &mut coin::TreasuryCap<suicraft_user::suicraft_regulated_coin::SUICRAFT_REGULATED_COIN>,
        amount: u64,
        recipient: address,
        ctx: &mut TxContext,
    ) {
        let coin = coin::mint(treasury_cap, amount, ctx);
        transfer::public_transfer(coin, recipient);
    }

    public entry fun burn(
        cap: &mut coin::TreasuryCap<suicraft_user::suicraft_regulated_coin::SUICRAFT_REGULATED_COIN>,
        c: coin::Coin<suicraft_user::suicraft_regulated_coin::SUICRAFT_REGULATED_COIN>
    ) {
        coin::burn(cap, c);
    }

    public entry fun freeze_treasury_cap(
        treasury_cap: coin::TreasuryCap<suicraft_user::suicraft_regulated_coin::SUICRAFT_REGULATED_COIN>,
    ) {
        transfer::public_freeze_object(treasury_cap);
    }
}