const { ethers } = require('hardhat');
const hre = require('hardhat');
const poseidonContract = require("circomlibjs").poseidonContract;
const BigNumber = ethers.BigNumber;
const snarkjs = require("snarkjs");

async function main() {
    const [owner, alice, bob] = await ethers.getSigners();

    const token = await hre.ethers.getContractAt("ZeroKnowledegToken", "0x0E801D84Fa97b50751Dbf25036d067dCf18858bF");

    console.log("Owner", owner.address);
    console.log(await token.balanceHashOf(owner.address));

    const { proof, publicSignals } = await snarkjs.plonk.fullProve(
        {
            balanceBefore: 1000,
            balanceTransfered: 200,
            hashBefore: "4718284119804185511257508371982628095258483864365234338531443234707945892862",
            hashAfter: "16446649868346601009699674591765222861264655253585198093558612919655912763886",
            hashTransfer: "9504599508303317455125540955207413179732841223639028228236710961709899388440"
        }, "./src/circuits/circuit_js/circuit.wasm", "./src/circuits/circuit_final.zkey"
    );

    console.log("Proof:", proof);

    token.transferWithProof(proof, publicSignals, alice.address, 200);

    console.log("After Transfer:", await token.balanceHashOf(owner.address))

    console.log(await token.name());
    console.log(await token.symbol());

    //console.log(await token.balanceHashOf(alice.address))
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
})
