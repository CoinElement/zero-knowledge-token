// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

import "../node_modules/@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "../src/circuits/verifier.sol";
import "./Poseidon.sol";
import "./MockPoseidon.sol";

contract ZeroKnowledegToken is ERC20 {
    PlonkVerifier private _verifier;
    MockPoseidon private _poseidon;
    mapping(address => uint256) private _balance;

    constructor(address verifier_, address poseidon)
        ERC20("Hashed Token", "HT")
    {
        _verifier = PlonkVerifier(verifier_);
        _poseidon = MockPoseidon(poseidon);
        _balance[msg.sender] = 1000;
    }

    function transferWithProof(
        bytes memory proof,
        uint[] memory pubSignals,
        address to,
        uint256 amount
    ) public returns (bool) {
        uint[] memory amountArray = new uint[](1);
        amountArray[0] = amount;

        require(_verifier.verifyProof(proof, pubSignals), "Verify Failed");

        require(pubSignals[0] == _balance[msg.sender], "HashBefore not match");

        uint[] memory balanceAfterArray = new uint[](1);
        balanceAfterArray[0] = _balance[msg.sender] - amount;

        require(
            pubSignals[1] == _poseidon.Hash(balanceAfterArray),
            "HashAfter not match"
        );

        require(
            pubSignals[2] == _poseidon.Hash(amountArray),
            "HashAmount not match"
        );

        super.transfer(to, amount);

        return (true);
    }

    function transfer(
        address, /* to */
        uint256 /* amount */
    ) public pure override returns (bool) {
        revert("ERC20ZKP: only transfers with zkp are allowed.");
    }

    function transferFrom(
        address, /* from */
        address, /* to */
        uint256 /* amount */
    ) public pure override returns (bool) {
        revert("ERC20ZKP: only transfers with zkp are allowed.");
    }

    function balanceOf(address) public pure override returns (uint256) {
        revert("ERC20ZKP: only balance of with zkp are allowed.");
    }

    function balanceHashOf(address account) public view returns (uint256) {
        uint[] memory balanceArray = new uint[](1);
        balanceArray[0] = _balance[account];
        return (_poseidon.Hash(balanceArray));
    }
}
