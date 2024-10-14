// SPDX-License-Identifier: MIT

pragma solidity ^0.8.28;

import {Test, console} from "forge-std/Test.sol";
import {HelperConfig} from "../script/HelperConfig.s.sol";
import {DeployNoSandwichSwapPair} from "../script/DeployNoSandwichSwapPair.s.sol";
import {NoSandwichSwapPair} from "../src/NoSandwichSwapPair.sol";
import {MyERC20Mock} from "../src/MyERC20Mock.sol";

contract NoSandwichSwapPairTest is Test {
    HelperConfig helperConfig;
    DeployNoSandwichSwapPair deployContract;
    NoSandwichSwapPair pair;

    address deployer;
    MyERC20Mock baseCurrency;
    MyERC20Mock quoteCurrency;

    constructor() {}

    function setUp() public {
        deployContract = new DeployNoSandwichSwapPair();
        (deployer, baseCurrency, quoteCurrency, pair) = deployContract.run();
    }
}
