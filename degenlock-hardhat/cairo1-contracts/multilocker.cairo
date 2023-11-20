#[contract]
mod Contract {
    struct Storage {
        balances: Mapping(Address, u64),
        lock_times: Mapping(Address, u64),   # The time the funds were locked
        lock_periods: Mapping(Address, u64), # The time period for which funds are locked
    }

    #[event]
    fn FundsLocked(sender: Address, amount: u64, until: u64) {}

    #[event]
    fn FundsClaimed(sender: Address, amount: u64) {}

    #[constructor]
    fn constructor() {
        # Initial setup if needed
    }

    #[external]
    fn lock_funds(period: u64) {
        let sender = get_sender();
        let value = get_value();

        # Check if sender has locked funds
        let current_balance = balances.get(sender, default=0);
        if current_balance > 0:
            raise "Sender already has funds locked"

        balances.write(sender, value);
        lock_times.write(sender, env::get_time());
        lock_periods.write(sender, period);

        FundsLocked(sender, value, env::get_time() + period);
    }

    #[external]
    fn claim_funds() {
        let sender = get_sender();

        let locked_since = lock_times.get(sender);
        let lock_period = lock_periods.get(sender);
        let current_balance = balances.get(sender);

        if env::get_time() < locked_since + lock_period:
            raise "Funds are still locked"

        balances.write(sender, 0);  # Clear the balance
        lock_times.write(sender, 0);  # Clear the lock time
        lock_periods.write(sender, 0);  # Clear the lock period

        FundsClaimed(sender, current_balance);
        # Add functionality to send tokens back to the user
    }

    #[view]
    fn get_locked_details(sender: Address) -> (u64, u64, u64) {
        let balance = balances.get(sender, default=0);
        let locked_since = lock_times.get(sender, default=0);
        let lock_period = lock_periods.get(sender, default=0);
        return (balance, locked_since, lock_period)
    }

    #[view]
    fn get_balance(sender: Address) -> u64 {
        return balances.get(sender, default=0)
    }

    fn get_sender() -> Address {
        msg::sender()
    }

    fn get_value() -> u64 {
        msg::value()
    }
}
