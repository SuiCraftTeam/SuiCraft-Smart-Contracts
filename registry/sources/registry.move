module suicraft_service::registry {
    use sui::event;
    use sui::coin::{Self};
    use sui::object::{Self, ID};
    use sui::tx_context::{Self, TxContext};

    struct CoinCreated has copy, drop  {
        meta_data_id: ID,
        creator: address,
    }

    public fun register_coin<T: drop>(
        meta_data: &coin::CoinMetadata<T>,
        ctx: &mut TxContext
    ) {
        event::emit(CoinCreated {
            meta_data_id: object::id(meta_data),
            creator: tx_context::sender(ctx)
        })
    }
}