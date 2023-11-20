import { expect } from "chai";
import { starknet } from "hardhat";
import { TIMEOUT } from "./constants";
import { getOZAccount } from "./util";
import { hash } from "starknet";

describe("Liquidity Locker", function () {
    this.timeout(TIMEOUT);
    let contract;
    let account;

    before(async function() {
        account = await getOZAccount();
        const contractFactory = await starknet.getContractFactory("LiquidityLocker");
        
        // Deploying the contract
        const deployFee = await account.estimateDeployFee(contractFactory, {});
        contract = await account.deploy(contractFactory, {}, { maxFee: deployFee.amount });
        console.log("Deployed contract at address: ", contract.address);
    });

    it("should allow user to lock funds", async function () {
        const lockPeriod = 60 * 60 * 24 * 7; // 1 week in seconds

        // Simulating user sending funds to the lock function
        const args = { period: BigInt(lockPeriod) };
        const fee = await account.estimateFee(contract, "lock_funds", args);
        const txHash = await account.invoke(contract, "lock_funds", args, { maxFee: fee.amount * 2n });

        const receipt = await starknet.getTransactionReceipt(txHash);
        if (receipt.status) {
            console.log(receipt.status);
        }

        const events = receipt.events;
        for (const event of events) {
            if (parseInt(event.from_address, 16) !== parseInt(contract.address, 16)) continue;
            const hashedEventName = event.keys[0];
            if (hashedEventName === hash.getSelectorFromName("FundsLocked")) {
                console.log("FundsLocked event was emitted");
                // TODO: add further assertions for event data if needed
            }
        }
    });

    it("should NOT allow user to claim funds before the lock period", async function () {
        try {
            const fee = await account.estimateFee(contract, "claim_funds", {});
            await account.invoke(contract, "claim_funds", {}, { maxFee: fee.amount * 2n });
            throw new Error("Claiming should have failed but it didn't");
        } catch (error) {
            expect(error.message).to.include("Funds are still locked");
        }
    });

    it("should provide details of locked funds", async function() {
        const details = await contract.call("get_locked_details", { sender: account.address });
        expect(details.response[0]).to.deep.equal("lock_funds");
        expect(details.response[1]).to.not.equal(0); // locked_since should be a non-zero value
        expect(details.response[2]).to.deep.equal("lock_funds");
    });

    it("should allow user to claim funds AFTER the lock period", async function () {
        // TODO: Simulate timelapse
        await starknet.devnet.increaseTime(60 * 60 * 24 * 7);

        const fee = await account.estimateFee(contract, "claim_funds", {});
        const txHash = await account.invoke(contract, "claim_funds", {}, { maxFee: fee.amount * 2n });
        
        const receipt = await starknet.getTransactionReceipt(txHash);
        if (receipt.status) {
            console.log(receipt.status);
        }

        const events = receipt.events;
        for (const event of events) {
            if (parseInt(event.from_address, 16) !== parseInt(contract.address, 16)) continue;
            const hashedEventName = event.keys[0];
            if (hashedEventName === hash.getSelectorFromName("FundsClaimed")) {
                console.log("FundsClaimed event was emitted");
                // TODO: Add more
            }
        }
    });
});
