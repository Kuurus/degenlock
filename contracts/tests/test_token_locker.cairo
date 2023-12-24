use core::debug::PrintTrait;
use openzeppelin::token::erc20::interface::{IERC20CamelDispatcher, IERC20CamelDispatcherTrait};
use snforge_std::{
    declare, ContractClassTrait, start_prank, stop_prank, start_warp, stop_warp, CheatTarget
};
use starknet::{ContractAddress, contract_address_const};
use starknet_forge_template::amm::amm::AMM;
use starknet_forge_template::multilocker::{ITokenLockerDispatcher, ITokenLockerDispatcherTrait};
use starknet_forge_template::tokens::interface::{
    Istarknet_forge_templateMemecoinDispatcher, Istarknet_forge_templateMemecoinDispatcherTrait
};
use openzeppelin::token::erc20::interface::{IERC20Dispatcher, IERC20DispatcherTrait};
use openzeppelin::token::erc20::{ERC20ABIDispatcher, ERC20ABIDispatcherTrait};
use starknet::contract_address_to_felt252;
fn setup() -> (ContractAddress, ContractAddress, ContractAddress) {
    let owner: ContractAddress = 'owner'.try_into().unwrap();
    let locker_calldata = array![];

    let locker_contract = declare('TokenLocker');
    let locker_address = locker_contract.deploy(@locker_calldata).unwrap();

    let initial_holder_2 = contract_address_const::<45>();
    let initial_holders: Span<ContractAddress> = array![owner, initial_holder_2].span();
    let initial_holders_amounts: Span<u256> = array![1000, 50].span();

    let mut token_calldata = array![
        owner.into(), locker_address.into(), 'TEST', 'TST', 100000.into(), 0.into()
    ];

    let amms: Array<AMM> = array![];
    Serde::serialize(@amms.into(), ref token_calldata);

    Serde::serialize(@initial_holders.into(), ref token_calldata);
    Serde::serialize(@initial_holders_amounts.into(), ref token_calldata);

    let token_contract = declare('starknet_forge_templateMemecoin');
    let token_address = token_contract.deploy(@token_calldata).unwrap();

    return (owner, locker_address, token_address);
}

#[test]
fn test_lock() {
    let (owner, locker, token) = setup();
    let token_dispatcher = Istarknet_forge_templateMemecoinDispatcher { contract_address: token };
    let locker_dispatcher = ITokenLockerDispatcher { contract_address: locker };

    let balance = token_dispatcher.balance_of(owner);
    balance.print();

    start_prank(CheatTarget::One(token), owner);
    token_dispatcher.approve(locker, 1000);
    stop_prank(CheatTarget::One(token));

    start_warp(CheatTarget::One(locker), 100);
    start_prank(CheatTarget::One(locker), owner);
    locker_dispatcher.lock(token, 1000, 200);
    stop_prank(CheatTarget::One(locker));

    assert(token_dispatcher.balance_of(owner) == 0, 'balance_of owner not 0');

    assert(token_dispatcher.balance_of(locker) == 1000, 'balance_of locker not 1000');

    assert(
        locker_dispatcher.get_locked_amount(token, owner, 100, 200) == 1000,
        'lockedAmount owner not 1000'
    );

    assert(locker_dispatcher.get_time_left(token, owner, 100, 200) == 200, 'time left not 200');
    stop_warp(CheatTarget::One(locker));
}


#[test]
fn test_lock_mytoken() {
    let (owner, locker, zizi) = setup();
    //declare 
    let token_d = declare('MyToken');
    let mut calldata: Array<felt252> = ArrayTrait::new();
    calldata.append(1000);
    calldata.append('zizicoin');
    calldata.append('zizi');
    let reciepient = contract_address_to_felt252(owner);
    calldata.append(reciepient);

    let token = token_d.deploy(@calldata).unwrap();
    let token_dispatcher = ERC20ABIDispatcher { contract_address: token };
    let locker_dispatcher = ITokenLockerDispatcher { contract_address: locker };

    assert(token_dispatcher.balance_of(owner) == 1000, 'balance_of owner not 1000');
    start_prank(CheatTarget::One(token), owner);
    token_dispatcher.approve(locker, 1000);
    stop_prank(CheatTarget::One(token));

    start_warp(CheatTarget::One(locker), 100);
    start_prank(CheatTarget::One(locker), owner);
    locker_dispatcher.lock(token, 1000, 200);
    stop_prank(CheatTarget::One(locker));

    assert(token_dispatcher.balance_of(owner) == 0, 'balance_of owner not 0');

    assert(token_dispatcher.balance_of(locker) == 1000, 'balance_of locker not 1000');

    assert(
        locker_dispatcher.get_locked_amount(token, owner, 100, 200) == 1000,
        'lockedAmount owner not 1000'
    );

    assert(locker_dispatcher.get_time_left(token, owner, 100, 200) == 200, 'time left not 200');
    stop_warp(CheatTarget::One(locker));
    

}


#[test]
#[should_panic(expected: ('Still locked',))]
fn test_unlock_early() {
    let (owner, locker, token) = setup();
    let token_dispatcher = Istarknet_forge_templateMemecoinDispatcher { contract_address: token };
    let locker_dispatcher = ITokenLockerDispatcher { contract_address: locker };

    start_prank(CheatTarget::One(token), owner);
    token_dispatcher.approve(locker, 1000);
    stop_prank(CheatTarget::One(token));

    start_warp(CheatTarget::One(locker), 100);
    start_prank(CheatTarget::One(locker), owner);
    locker_dispatcher.lock(token, 1000, 200);
    stop_prank(CheatTarget::One(locker));

    assert(token_dispatcher.balance_of(owner) == 0, 'balance_of owner not 0');

    start_warp(CheatTarget::One(locker), 200);
    start_prank(CheatTarget::One(locker), owner);
    locker_dispatcher.unlock(token, 100, 200);
    stop_prank(CheatTarget::One(locker));
    stop_warp(CheatTarget::One(locker));
}

#[test]
#[should_panic(expected: ('Lock nonexist',))]
fn test_unlock_no_owner() {
    let (owner, locker, token) = setup();
    let no_owner: ContractAddress = 'no_owner'.try_into().unwrap();
    let token_dispatcher = Istarknet_forge_templateMemecoinDispatcher { contract_address: token };
    let locker_dispatcher = ITokenLockerDispatcher { contract_address: locker };

    start_prank(CheatTarget::One(token), owner);
    token_dispatcher.approve(locker, 1000);
    stop_prank(CheatTarget::One(token));

    start_warp(CheatTarget::One(locker), 100);
    start_prank(CheatTarget::One(locker), owner);
    locker_dispatcher.lock(token, 1000, 200);
    stop_prank(CheatTarget::One(locker));

    assert(token_dispatcher.balance_of(owner) == 0, 'balance_of owner not 0');

    start_warp(CheatTarget::One(locker), 300);
    start_prank(CheatTarget::One(locker), no_owner);
    locker_dispatcher.unlock(token, 100, 200);
    stop_prank(CheatTarget::One(locker));
}

#[test]
fn test_unlock() {
    let (owner, locker, token) = setup();
    let token_dispatcher = Istarknet_forge_templateMemecoinDispatcher { contract_address: token };
    let locker_dispatcher = ITokenLockerDispatcher { contract_address: locker };

    start_prank(CheatTarget::One(token), owner);
    token_dispatcher.approve(locker, 1000);
    stop_prank(CheatTarget::One(token));

    start_warp(CheatTarget::One(locker), 100);
    start_prank(CheatTarget::One(locker), owner);
    locker_dispatcher.lock(token, 1000, 200);
    stop_prank(CheatTarget::One(locker));

    assert(token_dispatcher.balance_of(owner) == 0, 'balance_of owner not 0');

    start_warp(CheatTarget::One(locker), 300);
    start_prank(CheatTarget::One(locker), owner);
    locker_dispatcher.unlock(token, 100, 200);
    stop_prank(CheatTarget::One(locker));

    assert(token_dispatcher.balance_of(locker) == 0, 'balance_of locker not 0');

    assert(token_dispatcher.balance_of(owner) == 1000, 'balance_of owner not 1000');

    assert(locker_dispatcher.get_locked_amount(token, owner, 100, 200) == 0, 'lockedAmount owner not 0');

    assert(locker_dispatcher.get_time_left(token, owner, 100, 200) == 0, 'time left not 0');
    stop_warp(CheatTarget::One(locker));
}

#[test]
fn test_view_methods() {
    let (owner, locker, token) = setup();
    let token_dispatcher = Istarknet_forge_templateMemecoinDispatcher { contract_address: token };
    let locker_dispatcher = ITokenLockerDispatcher { contract_address: locker };

    start_prank(CheatTarget::One(token), owner);
    token_dispatcher.approve(locker, 1000);
    stop_prank(CheatTarget::One(token));

    start_warp(CheatTarget::One(locker), 100);
    start_prank(CheatTarget::One(locker), owner);
    locker_dispatcher.lock(token, 1000, 200);
    stop_prank(CheatTarget::One(locker));
    stop_warp(CheatTarget::One(locker));
}
