module suicraft_service::registry {
    use sui::event;
    use sui::coin::{Self};
    use sui::object::{Self, ID};
    use sui::tx_context::{Self, TxContext};

    struct CoinCreated has copy, drop  {
        treasury_cap: ID,
        deny_cap: ID,
        meta_data: ID,
        creator: address,
    }

    public fun register_coin<T: drop>(
        treasury_cap: &coin::TreasuryCap<T>,
        deny_cap: &coin::DenyCap<T>,
        meta_data: &coin::CoinMetadata<T>,
        ctx: &TxContext
    ) {
        event::emit(CoinCreated {
            treasury_cap: object::id(treasury_cap),
            deny_cap: object::id(deny_cap),
            meta_data: object::id(meta_data),
            creator: tx_context::sender(ctx),
       })
    }
}