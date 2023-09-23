import { expect } from "chai";
import { starknet } from "hardhat";
import { TIMEOUT } from "./constants";
import { getOZAccount } from "./util";
import { hash } from "starknet";

export interface StringMap {
    [key: string]: string;
}

export interface DecodedEvent {
    name: string;
    data: StringMap;
}

describe("Class declaration", function () {
    this.timeout(TIMEOUT);
    it("should declare using declare v2 and interact with the class", async function () {
        const account = await getOZAccount();

        const contractFactory = await starknet.getContractFactory("cairo1");
        // const declareFee = await account.estimateDeclareFee(contractFactory);
        // console.log("Estimated declare fee: ", declareFee);
        const declareTxHash = await account.declare(contractFactory, { maxFee: 1e18 });
        console.log("Declare v2 Tx Hash: ", declareTxHash);
        const deployFee = await account.estimateDeployFee(contractFactory, {
            initial_balance: 10n
        });
        console.log("Estimated deploy fee: ", deployFee);

        const contract = await account.deploy(
            contractFactory,
            {
                initial_balance: 10n
            },
            { maxFee: deployFee.amount }
        );

        console.log("Deployed contract at address: ", contract.address);

        const balanceBefore = await contract.call("get_balance");
        expect(balanceBefore.response).to.deep.equal(10n);

        const args = { amount: 10n };
        const fee = await account.estimateFee(contract, "increase_balance", args);
        console.log("Estimated invoke fee:", fee);

        const txHashIncreaseBalance = await account.invoke(contract, "increase_balance", args, { maxFee: fee.amount * 2n });
        console.log("Increased balance");

        const receiptIncreaseBalance = await starknet.getTransactionReceipt(txHashIncreaseBalance);
        if (receiptIncreaseBalance.status) {
            console.log(receiptIncreaseBalance.status);
        }

        const eventsIncreaseBalance = receiptIncreaseBalance.events;

        for (const event of eventsIncreaseBalance) {
            // skip events originating from other contracts, e.g. fee token
            if (parseInt(event.from_address, 16) !== parseInt(contract.address, 16)) continue;

            const rawEventData = event.data.map(BigInt).join(" ");
            // encoded event name guaranteed to be at index 0
            const hashedEventName = event.keys[0];
            if (hashedEventName === hash.getSelectorFromName("BalanceIncreased")) {
                console.log("BalanceIncreased event was emitted");
                expect(rawEventData).to.deep.equal("20");
            }
        }

        const balanceAfter = await contract.call("get_balance");
        console.log("balance after", balanceAfter.response);
        expect(balanceAfter.response).to.deep.equal(20n);
    });
    it("should fund a Argent X wallet", async function () {
        await starknet.devnet.mint("0x00382a38e6dE389D0325fc372c33717793bbbAD4a6Cd87368DAedb9ea4b6D504", 100000000000000000);
    });
});
