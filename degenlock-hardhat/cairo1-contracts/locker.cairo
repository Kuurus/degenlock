%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import (Uint256, uint256_add)
from starkware.starknet.common.syscalls import get_caller_address
from starkware.starknet.common.syscalls import get_contract_address
from starkware.cairo.common.math import assert_not_equal


@contract_interface
namespace IERC20 {
    func transferFrom(sender: felt, recipient: felt, amount: Uint256) -> (success: felt) {
    }
}


// We call the get tokens function to have tokens in our contract

@constructor
func constructor{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
) {
    get_tokens_from_contract_for(address=0x14ece8a1dcdcc5a56f01a987046f2bd8ddfb56bc358da050864ae6da5f71394);
    return ();
}


@storage_var
func claims(account: felt) -> (total: Uint256) {
}

@view
func tokens_in_custody{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(account: felt) -> (total: Uint256) {
    return claims.read(account);
}


@external
func withdraw_all_tokens{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (amount: Uint256, contract: ContractAddress) {
      let (me) = get_contract_address();
      let (caller) = get_caller_address();
      //Look token in custody
      let (am) = tokens_in_custody(caller);
      let (is_ok) = IERC20.transferFrom(contract_address=contract, sender=me, recipient=caller, amount=am);
      with_attr error_message("problem transferring the tokens") {
        assert is_ok = 1;
      }
      //Should emit event
      return (am,);
}

@external
func deposit_tokens{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
  amount: Uint256,timelock: Uint256 ,contract: ContractAddress
) -> (total: Uint256) {
    let (caller) = get_caller_address();
    let (me) = get_contract_address();
    //Store information that the user have locked a token for x amount of time

    IERC20.transferFrom(contract_address=contract, sender=caller, recipient=me, amount=amount);
    let (current) = claims.read(caller);  
    let (new_total,_) = uint256_add(current, amount);
    //Should event
    claims.write(caller, new_total);
    return (new_total,);
}