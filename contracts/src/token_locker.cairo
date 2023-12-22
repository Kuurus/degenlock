use starknet::ContractAddress;
use starknet::{syscalls, testing};
use starknet::{ClassHash, SyscallResult};
use traits::{ Into, TryInto };
use option::OptionTrait;
#[starknet::interface]
trait IHelloStarknet<TContractState> {
    fn increase_balance(ref self: TContractState, amount: felt252);
    fn get_balance(self: @TContractState) -> felt252;
    fn deploy_contract(ref self: TContractState, contract_code: ClassHash, constructor: Array<felt252>)-> ContractAddress;
}

#[starknet::contract]
mod HelloStarknet {
    use core::starknet::SyscallResultTrait;
    use starknet::{ClassHash, SyscallResult};
    use starknet_forge_template::token_locker::HelloStarknetT;
    use starknet::ContractAddress;
    use starknet::syscalls::deploy_syscall;
    use core::result::ResultTrait;
    use starknet::{syscalls, testing};
    use traits::{ Into, TryInto };
    use option::OptionTrait;
    use array::ArrayTrait;
    use openzeppelin::token::erc20::interface::{IERC20CamelDispatcher, IERC20CamelDispatcherTrait};
    #[storage]
    struct Storage {
        balance: felt252, 
        salt: felt252
    }
    
    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        TokenDeployed: TokenDeployed
    }

    #[derive(Drop, starknet::Event)]
    struct TokenDeployed {
        erc20: ContractAddress,
        owner: ContractAddress
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
        fn deploy_contract(ref self: ContractState, contract_code : ClassHash, constructor : Array<felt252>) -> ContractAddress {
            let caller = starknet::get_caller_address();
            let salt_local=self.salt.read();
            self.salt.write(salt_local + 1);
           
            //Deploy a new contract using deploy_syscall
            let res = syscalls::deploy_syscall(contract_code, salt_local, constructor.span(), false);
           //syscalls::deploy_syscall(contract_code.try_into().unwrap(), 0, array![].span(), false);
             //syscalls::deploy_syscall(contract_code.try_into().unwrap(), 1, array![].span(), false);
            let (address, _) = res.unwrap_syscall();
              self
                .emit(
                    TokenDeployed {
                        erc20: address,
                        owner: caller,
                    }
                );
                 self.salt.write(salt_local + 1);
                address
        
       
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
            //let (address, _)= starknet::syscalls::deploy_syscall(HelloStarknetT::TEST_CLASS_HASH.try_into().unwrap(), 1, array![].span(), false);
             //syscalls::deploy_syscall(contract_code.try_into().unwrap(), 1, array![].span(), false);
           
    
       
        }
         
        
        fn get_balance(self: @ContractState) -> felt252 {
            self.balance.read()
        }
    }
}

#[starknet::contract]
mod MyToken {
    use openzeppelin::token::erc20::ERC20Component;
    use starknet::ContractAddress;
    use starknet::contract_address_try_from_felt252;
    use core::integer::{u256_from_felt252};

    component!(path: ERC20Component, storage: erc20, event: ERC20Event);

    #[abi(embed_v0)]
    impl ERC20Impl = ERC20Component::ERC20Impl<ContractState>;
    #[abi(embed_v0)]
    impl ERC20MetadataImpl = ERC20Component::ERC20MetadataImpl<ContractState>;
    impl ERC20InternalImpl = ERC20Component::InternalImpl<ContractState>;

    #[storage]
    struct Storage {
        #[substorage(v0)]
        erc20: ERC20Component::Storage
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        #[flat]
        ERC20Event: ERC20Component::Event
    }

    #[constructor]
    fn constructor(ref self: ContractState, initial : felt252, name:felt252, symbol:felt252, recipient_felt : felt252 ) {
       
        let initial_supply = u256_from_felt252(initial);
        let recipient : ContractAddress = contract_address_try_from_felt252(recipient_felt).unwrap();
        
        self.erc20.initializer(name, symbol);
        self.erc20._mint(recipient, initial_supply);
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