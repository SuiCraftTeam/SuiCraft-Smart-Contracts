module suicraft_service::coin_issuance {
    use std::string;
    use sui::transfer;
    use sui::event;
    use sui::sui::SUI;
    use sui::coin::{Self, Coin};
    use sui::object::{Self, UID};
    use sui::balance::{Self, Balance};
    use sui::tx_context::{Self, TxContext};
    use std::type_name;

    const EBadWitness: u64 = 0;
    const ENotEnough: u64 = 1;

    struct OwnerCap has key, store { id: UID }

    struct ServiceProvider has key {
        id: UID,
        balance: Balance<SUI>,
    }

    struct CoinOperation has copy, drop  {
        authority: address,
        coin_type: string::String,
        operation: string::String
    }

    fun init(ctx: &mut TxContext) {
        transfer::transfer(OwnerCap {
            id: object::new(ctx)
        }, tx_context::sender(ctx));

        transfer::share_object(ServiceProvider {
            id: object::new(ctx),
            balance: balance::zero(),
        });
    }

    public entry fun emit_coin_operation<T: drop>(
        op: vector<u8>,
        ctx: &TxContext
    ) {
        event::emit(CoinOperation {
            authority: tx_context::sender(ctx),
            coin_type: string::from_ascii(type_name::into_string(type_name::get_with_original_ids<T>())),
            operation: string::utf8(op)
        });
    }

    public entry fun pay_for_service(
        provider: &mut ServiceProvider,
        payment: &mut Coin<SUI>,
        price: u64,
    ) {
        assert!(coin::value(payment) >= price, ENotEnough);

        let coin_balance = coin::balance_mut(payment);
        let paid = balance::split(coin_balance, price);

        balance::join(&mut provider.balance, paid);
    }

    public entry fun collect_profits(
        _: &OwnerCap,
        provider: &mut ServiceProvider,
        ctx: &mut TxContext
    ) {
        let amount = balance::value(&provider.balance);
        let profits = coin::take(&mut provider.balance, amount, ctx);

        transfer::public_transfer(profits, tx_context::sender(ctx));
    }

    public entry fun transfer_owner_cap(
        owner_cap: OwnerCap,
        to: address
    ) {
        transfer::public_transfer(owner_cap, to);
    }

}