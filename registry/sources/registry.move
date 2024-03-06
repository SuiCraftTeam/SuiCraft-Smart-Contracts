module suicraft_service::registry {
    use sui::event;
    use sui::coin::{Self};
    use sui::object::{Self, ID};

    struct CoinCreated has copy, drop  {
        meta_data_id: ID
    }

    public fun register_coin<T: drop>(
        meta_data: &coin::CoinMetadata<T>,
    ) {
        event::emit(CoinCreated {
            meta_data_id: object::id(meta_data),
        })
    }
}