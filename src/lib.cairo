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
