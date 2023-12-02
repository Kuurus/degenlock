use starknet::ContractAddress;
use starknet::{syscalls, testing};
use traits::TryInto;
use option::OptionTrait;
use starknet::{ClassHash, SyscallResult};
#[starknet::interface]
trait IHelloStarknet<TContractState> {
    fn increase_balance(ref self: TContractState, amount: felt252);
    fn get_balance(self: @TContractState) -> felt252;
    fn deploy_contract(ref self: TContractState, contract_code: ClassHash) ;
}

#[starknet::contract]
mod HelloStarknet {
    use starknet::{ClassHash, SyscallResult};
    use starknet_forge_template::HelloStarknetT;
    use starknet::ContractAddress;
    use starknet::syscalls::deploy_syscall;
    use core::result::ResultTrait;
    use starknet::{syscalls, testing};
    use traits::TryInto;
    use option::OptionTrait;
    #[storage]
    struct Storage {
        balance: felt252, 
    }

    #[constructor]
    fn constructor(
        ref self: ContractState
    ) {
        let name = 'MyToken';
        let symbol = 'MTK';
        
    }

    

    #[external(v0)]
    impl HelloStarknetImpl of super::IHelloStarknet<ContractState> {
        fn increase_balance(ref self: ContractState, amount: felt252) {
            assert(amount != 0, 'Amount cannot be 0');
            self.balance.write(self.balance.read() + amount);
        }

         // Function to deploy challenges to players
        fn deploy_contract(ref self: ContractState, contract_code : ClassHash)  {
            
           
            //Deploy a new contract using deploy_syscall
           syscalls::deploy_syscall(contract_code, 1, array![].span(), false);
           //syscalls::deploy_syscall(contract_code.try_into().unwrap(), 0, array![].span(), false);
             //syscalls::deploy_syscall(contract_code.try_into().unwrap(), 1, array![].span(), false);
         
    
       
        }
         
        
        fn get_balance(self: @ContractState) -> felt252 {
            self.balance.read()
        }
    }
}
#[starknet::interface]
trait IHelloStarknetT<TContractState> {
    fn increase_balance(ref self: TContractState, amount: felt252);
    fn get_balance(self: @TContractState) -> felt252;
    fn deploy_contract(ref self: TContractState, contract_code: felt252) ;
}

#[starknet::contract]
mod HelloStarknetT {
    use starknet::ContractAddress;
    use starknet::syscalls::deploy_syscall;
    use core::result::ResultTrait;
    use starknet::{syscalls, testing};
    use traits::TryInto;
    use option::OptionTrait;
    #[storage]
    struct Storage {
        balance: felt252, 
    }

    #[constructor]
    fn constructor(
        ref self: ContractState
    ) {
        let name = 'MyToken';
        let symbol = 'MTK';
        
    }

    

    #[external(v0)]
    impl HelloStarknetTImpl of super::IHelloStarknetT<ContractState> {
        fn increase_balance(ref self: ContractState, amount: felt252) {
            assert(amount != 0, 'Amount cannot be 0');
            self.balance.write(self.balance.read() + amount);
        }

         // Function to deploy challenges to players
        fn deploy_contract(ref self: ContractState, contract_code : felt252)  {
            
           
            //Deploy a new contract using deploy_syscall
            //let (address, _)= starknet::syscalls::deploy_syscall(HelloStarknetT::TEST_CLASS_HASH.try_into().unwrap(), 1, array![].span(), false)?;
             //syscalls::deploy_syscall(contract_code.try_into().unwrap(), 1, array![].span(), false);
           
    
       
        }
         
        
        fn get_balance(self: @ContractState) -> felt252 {
            self.balance.read()
        }
    }
}

#[starknet::contract]
mod MyToken {
    use starknet::ContractAddress;
    use openzeppelin::token::erc20::ERC20;

    #[storage]
    struct Storage {}

    #[constructor]
    fn constructor(ref self: ContractState, recipient: ContractAddress) {
        let name = 'Pepecoin';
        let symbol = 'PEPE';
        let initial_supply = 125;
        let recipient = starknet::contract_address_const::<0x01>();

        let mut unsafe_state = ERC20::unsafe_new_contract_state();
        ERC20::InternalImpl::initializer(ref unsafe_state, name, symbol);
        ERC20::InternalImpl::_mint(ref unsafe_state, recipient, initial_supply);
    }

    #[external(v0)]
    fn name(self: @ContractState) -> felt252 {
        let unsafe_state = ERC20::unsafe_new_contract_state();
        ERC20::ERC20Impl::name(@unsafe_state)
    }

    #[external(v0)]
    fn total_supply(self: @ContractState) -> u256 {
        let unsafe_state = ERC20::unsafe_new_contract_state();
        ERC20::ERC20Impl::total_supply(@unsafe_state)
    }

    #[external(v0)]
    fn balance_of(self: @ContractState, account: ContractAddress) -> u256 {
        let unsafe_state = ERC20::unsafe_new_contract_state();
        ERC20::ERC20Impl::balance_of(@unsafe_state, account)
    }

    #[external(v0)]
    fn transfer(ref self: ContractState, recipient: ContractAddress, amount: u256) {
        let mut unsafe_state = ERC20::unsafe_new_contract_state();
        ERC20::ERC20Impl::transfer(ref unsafe_state, recipient, amount);
    }

    #[external(v0)]
    fn allowance(
        ref self: ContractState, owner: ContractAddress, spender: ContractAddress
    ) -> u256 {
        let unsafe_state = ERC20::unsafe_new_contract_state();
        ERC20::ERC20Impl::allowance(@unsafe_state, owner, spender)
    }

    #[external(v0)]
    fn approve(ref self: ContractState, spender: ContractAddress, amount: u256) -> bool {
        let mut unsafe_state = ERC20::unsafe_new_contract_state();
        ERC20::ERC20Impl::approve(ref unsafe_state, spender, amount)
    }

    #[external(v0)]
    fn transfer_from(
        ref self: ContractState, sender: ContractAddress, recipient: ContractAddress, amount: u256
    ) -> bool {
        let mut unsafe_state = ERC20::unsafe_new_contract_state();
        ERC20::ERC20Impl::transfer_from(ref unsafe_state, sender, recipient, amount)
    }

    #[external(v0)]
    fn symbol(self: @ContractState) -> felt252 {
        let unsafe_state = ERC20::unsafe_new_contract_state();
        ERC20::ERC20Impl::symbol(@unsafe_state)
    }

    #[external(v0)]
    fn decimals(self: @ContractState) -> u8 {
        let unsafe_state = ERC20::unsafe_new_contract_state();
        ERC20::ERC20Impl::decimals(@unsafe_state)
    }
}

#[starknet::interface]
trait IERC20<TContractState> {
    fn name(self: @TContractState) -> felt252;

    fn symbol(self: @TContractState) -> felt252;

    fn decimals(self: @TContractState) -> u8;

    fn total_supply(self: @TContractState) -> u256;

    fn balance_of(self: @TContractState, account: ContractAddress) -> u256;

    fn allowance(self: @TContractState, owner: ContractAddress, spender: ContractAddress) -> u256;

    fn transfer(ref self: TContractState, recipient: ContractAddress, amount: u256) -> bool;

    fn transfer_from(
        ref self: TContractState, sender: ContractAddress, recipient: ContractAddress, amount: u256
    ) -> bool;

    fn approve(ref self: TContractState, spender: ContractAddress, amount: u256) -> bool;
}

#[starknet::contract]
mod Locker {
    use starknet::get_caller_address;
    use starknet::get_contract_address;
    use super::{IERC20DispatcherTrait, IERC20LibraryDispatcher};
    use starknet::{ContractAddress, SyscallResult};
    #[storage]
    struct Storage {
        balances: LegacyMap::<ContractAddress, u256>,
        lock_time: LegacyMap::<ContractAddress, felt252>  // TODO: Use blocktime & add locktime
    }

    #[generate_trait]
    #[external(v0)]
    impl ERC20 of IERC20 {
        fn deposit(
            ref self: ContractState, sender: ContractAddress, amount: u256
        ) -> bool {
            let recipient = get_contract_address();
            IERC20LibraryDispatcher { class_hash: starknet::class_hash_const::<0x1234>() }  // TODO: check sender token address ?
                .transfer_from(sender, recipient, amount);
            let current_balance = self.balances.read(sender);
            self.balances.write(sender, current_balance + amount);
            return true;
        }

        fn withdraw(
            ref self: ContractState, sender: ContractAddress, amount: u256
        ) -> bool {
            let current_balance = self.balances.read(sender);
            if amount > current_balance {
                return false;
            }
            let recipient = get_contract_address();
            IERC20LibraryDispatcher { class_hash: starknet::class_hash_const::<0x1234>() }  // TODO: check sender token address ?
                .transfer_from(recipient, sender, amount);
            self.balances.write(sender, current_balance - amount);
            return true;
        }
    }
}