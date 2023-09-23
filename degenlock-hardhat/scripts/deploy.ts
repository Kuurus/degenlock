import hardhat from "hardhat";
import { getOZAccountForDeploy } from "../test/util";

async function main() {
    let account = null;
    if (hardhat.starknet.network === "alphaGoerli") {
        return;
    } else {
        account = await getOZAccountForDeploy();
    }
    const contractFactory = await hardhat.starknet.getContractFactory("cairo1");
    await account.declare(contractFactory, { maxFee: 1e18 });
    const contract = await account.deploy(contractFactory, { initial_balance: 0 });
    console.log("Deployed to:", contract.address);
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
