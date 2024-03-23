module suicraft_user::non_fungible_token {
    use sui::url::{Self, Url};
    use std::string;
    use sui::object::{Self, ID, UID};
    use sui::event;
    use sui::package;
    use sui::transfer;
    use sui::tx_context::{Self, TxContext};

    struct NON_FUNGIBLE_TOKEN has drop {}

    struct AuthorityCap has key, store { id: UID }

    struct NFT has key, store {
        id: UID,
        name: string::String,
        description: string::String,
        url: Url,
    }

    struct Minted has copy, drop {
        object_id: ID,
        creator: address,
        name: string::String,
    }

    fun init(otw: NON_FUNGIBLE_TOKEN, ctx: &mut TxContext) {
        package::claim_and_keep(otw, ctx);

        transfer::transfer(AuthorityCap {
            id: object::new(ctx),
        }, tx_context::sender(ctx));
    }

    public fun name(nft: &NFT): &string::String {
        &nft.name
    }

    public fun description(nft: &NFT): &string::String {
        &nft.description
    }

    public fun url(nft: &NFT): &Url {
        &nft.url
    }

    public entry fun update_name(
        nft: &mut NFT,
        new_name: vector<u8>,
        _: &mut TxContext
    ) {
        nft.name = string::utf8(new_name)
    }

    public entry fun update_description(
        nft: &mut NFT,
        new_description: vector<u8>,
        _: &mut TxContext
    ) {
        nft.description = string::utf8(new_description)
    }

    public entry fun update_url(
        nft: &mut NFT,
        new_url: vector<u8>,
        _: &mut TxContext
    ) {
        nft.url = url::new_unsafe_from_bytes(new_url)
    }

    public entry fun mint(
        _: &AuthorityCap,
        name: vector<u8>,
        description: vector<u8>,
        url: vector<u8>,
        ctx: &mut TxContext
    ) {
        let sender = tx_context::sender(ctx);
        let nft = NFT {
            id: object::new(ctx),
            name: string::utf8(name),
            description: string::utf8(description),
            url: url::new_unsafe_from_bytes(url)
        };

        event::emit(Minted {
            object_id: object::id(&nft),
            creator: sender,
            name: nft.name,
        });

        transfer::public_transfer(nft, sender);
    }

    public entry fun transfer(
        nft: NFT,
        recipient: address,
        _: &mut TxContext
    ) {
        transfer::public_transfer(nft, recipient);
    }

    public entry fun burn(
        nft: NFT,
        _: &mut TxContext
    ) {
        let NFT { id, name: _, description: _, url: _ } = nft;
        object::delete(id);
    }
}
