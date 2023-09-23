#[contract]
mod Contract {
    struct Storage {
        balance: u64,
    }

    #[event]
    fn BalanceIncreased(amount: u64) {}

    #[constructor]
    fn constructor(initial_balance: u64) {
        balance::write(initial_balance);
    }

    #[external]
    fn increase_balance(amount: u64) {
        let new_balance = balance::read() + amount;
        balance::write(new_balance);
        BalanceIncreased(new_balance);
    }

    #[view]
    fn get_balance() -> u64 {
        balance::read()
    }
 
    fn get_sender() -> Address {
        msg::sender()
    }

    fn get_value() -> u64 {
        msg::value()
    }
}
