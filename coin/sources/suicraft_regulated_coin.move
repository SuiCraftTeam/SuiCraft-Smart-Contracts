module suicraft_user::suicraft_regulated_coin {
    use sui::package;
    use sui::deny_list;
    use std::option;
    use sui::coin;
    use sui::transfer;
    use sui::tx_context::{Self, TxContext};
    use suicraft_service::coin_issuance;

    struct SUICRAFT_REGULATED_COIN has drop {}

    fun init(otw: SUICRAFT_REGULATED_COIN, ctx: &mut TxContext) {
        coin_issuance::emit_coin_created(&otw, ctx);

        let (treasury_cap, deny_cap, meta_data) = coin::create_regulated_currency(
            otw,
            9,
            b"$MYCOIN",
            b"My Coin",
            b"Created using https://suicraft.xyz",
            option::none(),
            ctx
        );

        let sender = tx_context::sender(ctx);
        transfer::public_transfer(treasury_cap, sender);
        transfer::public_transfer(deny_cap, sender);
        transfer::public_transfer(meta_data, sender);
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

    // public entry fun burn(
    //     cap: &mut coin::TreasuryCap<suicraft_user::suicraft_regulated_coin::SUICRAFT_REGULATED_COIN>,
    //     c: coin::Coin<suicraft_user::suicraft_regulated_coin::SUICRAFT_REGULATED_COIN>
    // ) {
    //     coin::burn(cap, c);
    // }

    public entry fun freeze_meta_data(
        metadata: coin::CoinMetadata<suicraft_user::suicraft_regulated_coin::SUICRAFT_REGULATED_COIN>
    ) {
        transfer::public_freeze_object(metadata);
    }

    public entry fun freeze_deny_cap(
        denycap: coin::DenyCap<suicraft_user::suicraft_regulated_coin::SUICRAFT_REGULATED_COIN>,
    ) {
        transfer::public_freeze_object(denycap);
    }

    public entry fun freeze_treasury_cap(
        treasury_cap: coin::TreasuryCap<suicraft_user::suicraft_regulated_coin::SUICRAFT_REGULATED_COIN>,
    ) {
        transfer::public_freeze_object(treasury_cap);
    }

    public entry fun freeze_upgrade_cap(
        upgrade_cap: package::UpgradeCap,
    ) {
        transfer::public_freeze_object(upgrade_cap);
    }

    public entry fun transfer_meta_data(
        meta_data: sui::coin::CoinMetadata<suicraft_user::suicraft_regulated_coin::SUICRAFT_REGULATED_COIN>,
        recipient: address,
    ) {
        transfer::public_transfer(meta_data, recipient);
    }

    public entry fun transfer_deny_cap(
        deny_cap: coin::DenyCap<suicraft_user::suicraft_regulated_coin::SUICRAFT_REGULATED_COIN>,
        recipient: address,
    ) {
        transfer::public_transfer(deny_cap, recipient);
    }

    public entry fun transfer_treasury_cap(
        treasury_cap: coin::TreasuryCap<suicraft_user::suicraft_regulated_coin::SUICRAFT_REGULATED_COIN>,
        recipient: address,
    ) {
        transfer::public_transfer(treasury_cap, recipient);
    }

    public entry fun transfer_upgrade_cap(
        upgrade_cap: package::UpgradeCap,
        recipient: address,
    ) {
        transfer::public_transfer(upgrade_cap, recipient);
    }
}