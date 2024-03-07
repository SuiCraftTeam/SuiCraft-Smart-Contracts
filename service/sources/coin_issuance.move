module suicraft_service::coin_issuance {
    use sui::transfer;
    use sui::event;
    use sui::sui::SUI;
    use sui::coin::{Self, Coin};
    use sui::object::{Self, ID, UID};
    use sui::balance::{Self, Balance};
    use sui::tx_context::{Self, TxContext};

    const ENotEnough: u64 = 0;

    struct OwnerCap has key { id: UID }

    struct ServiceProvider has key {
        id: UID,
        price: u64,
        balance: Balance<SUI>
    }

    struct CoinCreated has copy, drop  {
        treasury_cap: ID,
        deny_cap: ID,
        meta_data: ID,
        creator: address,
    }

    fun init(ctx: &mut TxContext) {
        transfer::transfer(OwnerCap {
            id: object::new(ctx)
        }, tx_context::sender(ctx));

        transfer::share_object(ServiceProvider {
            id: object::new(ctx),
            price: 3000000000,
            balance: balance::zero()
        });
    }

    public entry fun pay_for_service(
        provider: &mut ServiceProvider,
        payment: &mut Coin<SUI>
    ) {
        assert!(coin::value(payment) >= provider.price, ENotEnough);

        let coin_balance = coin::balance_mut(payment);
        let paid = balance::split(coin_balance, provider.price);

        balance::join(&mut provider.balance, paid);
    }

    public entry fun collect_profits(
        _: &OwnerCap,
        provider: &mut ServiceProvider,
        ctx: &mut TxContext
    ) {
        let amount = balance::value(&provider.balance);
        let profits = coin::take(&mut provider.balance, amount, ctx);

        transfer::public_transfer(profits, tx_context::sender(ctx))
    }

    public entry fun set_price(
        _: &OwnerCap,
        provider: &mut ServiceProvider,
        price: u64
    ) {
        provider.price = price;
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