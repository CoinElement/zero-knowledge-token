const { ethers } = require('hardhat');
const hre = require('hardhat');
const poseidonContract = require("circomlibjs").poseidonContract;

async function main() {
    const [owner, alice, bob] = await ethers.getSigners();

    console.log(`owner: ${owner.address}, alice: ${alice.address}, bob: ${bob.address}`)

    const Verifier = await hre.ethers.getContractFactory("PlonkVerifier", owner);
    const verifier = await Verifier.deploy();

    console.log("Verifier Address", verifier.address);

    const poseidon = await deployPoseidon();

    console.log("Poseidon Address", poseidon.address);

    const Token = await hre.ethers.getContractFactory("ZeroKnowledegToken", owner);
    const token = await Token.deploy(verifier.address, poseidon.address);

    console.log("Token Address", token.address);

    console.log(await token.name());
    console.log(await token.symbol());
}

async function deployPoseidon(owner) {
    const Poseidon = await ethers.getContractFactory("MockPoseidon", owner);
    const poseidon = await Poseidon.deploy();
    return poseidon;
}

// async function deployPoseidon() {
//     const [owner] = await ethers.getSigners();
//     const PoseidonCircomLib = await ethers.getContractFactoryFromArtifact({
//         contractName: "",
//         sourceName: "",
//         abi: poseidonContract.generateABI(1),
//         bytecode: poseidonContract.createCode(1),
//         deployedBytecode: "",
//         linkReferences: {},
//         deployedLinkReferences: {}
//     }, owner);

//     const poseidonCircomLib = await PoseidonCircomLib.deploy();
//     await poseidonCircomLib.deployed()

//     console.log("Poseidon Circom Lib Address", poseidonCircomLib.address);

//     const Poseidon = await hre.ethers.getContractFactory("Poseidon");
//     const poseidonSC = await Poseidon.deploy(poseidonCircomLib.address);
//     await poseidonSC.deployed();
//     return poseidonSC;
// }

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
})
