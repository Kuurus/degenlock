use starknet::ContractAddress;
use starknet::{syscalls, testing};
#[starknet::interface]
trait IHelloStarknet<TContractState> {
    fn increase_balance(ref self: TContractState, amount: felt252);
    fn get_balance(self: @TContractState) -> felt252;
    fn deploy_contract(ref self: TContractState, contract_code: felt252) ;
}

#[starknet::contract]
mod HelloStarknet {
    use starknet::ContractAddress;
    use starknet::syscalls::deploy_syscall;
    use core::result::ResultTrait;
    use starknet::{syscalls, testing};

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
        fn deploy_contract(ref self: ContractState, contract_code : felt252)  {
            
           
            //Deploy a new contract using deploy_syscall
            syscalls::deploy_syscall(contract_code.try_into().unwrap(), 0, array![].span(), false);
           
    
       
        }
         
        
        fn get_balance(self: @ContractState) -> felt252 {
            self.balance.read()
        }
    }
}
