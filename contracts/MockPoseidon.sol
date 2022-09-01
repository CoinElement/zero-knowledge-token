// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

import "./Poseidon.sol";

contract MockPoseidon {
    mapping(uint256 => uint256) private _poseidonMapping;

    constructor() {
        _poseidonMapping[0] = 4564564564564564654204040894089484098410654;
        _poseidonMapping[
            1000
        ] = 4718284119804185511257508371982628095258483864365234338531443234707945892862;
        _poseidonMapping[
            800
        ] = 16446649868346601009699674591765222861264655253585198093558612919655912763886;
        _poseidonMapping[
            200
        ] = 9504599508303317455125540955207413179732841223639028228236710961709899388440;
    }

    function Hash(uint256[] memory inp) public view returns (uint256) {
        return _poseidonMapping[inp[0]];
    }
}
