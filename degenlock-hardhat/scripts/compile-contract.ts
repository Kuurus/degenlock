import hardhat from "hardhat";

async function main() {
    await hardhat.run("starknet-compile-cairo1", {
        paths: ["cairo1-contracts/cairo1.cairo"]
    });
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
