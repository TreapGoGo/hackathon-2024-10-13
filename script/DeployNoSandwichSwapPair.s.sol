// SPDX-License-Identifier: MIT

pragma solidity ^0.8.28;

import {Script, console} from "forge-std/Script.sol";
import {HelperConfig} from "./HelperConfig.s.sol";
import {MyERC20Mock} from "../src/MyERC20Mock.sol";
import {NoSandwichSwapPair} from "../src/NoSandwichSwapPair.sol";

contract DeployNoSandwichSwapPair is Script {
    uint256 constant SETTLEMENT_TIME_INTERVAL = 1 minutes;
    uint256 constant NUMBER_OF_FRAGMENTS = 100;

    HelperConfig helperConfig;

    MyERC20Mock baseCurrency;
    MyERC20Mock quoteCurrency;

    NoSandwichSwapPair pair;

    constructor() {}

    function run()
        external
        returns (address, MyERC20Mock, MyERC20Mock, NoSandwichSwapPair)
    {
        helperConfig = new HelperConfig();
        uint256 deployerKey = helperConfig.activeNetworkConfig();
        address deployer = vm.addr(deployerKey);

        console.log("deployer: ", deployer);

        vm.startBroadcast(deployerKey);

        baseCurrency = new MyERC20Mock("Base", "BASE", deployer);
        quoteCurrency = new MyERC20Mock("Quote", "QUOTE", deployer);

        baseCurrency.mint(deployer, 10000 ether);
        quoteCurrency.mint(deployer, 10000 ether);

        pair = new NoSandwichSwapPair(
            address(baseCurrency),
            address(quoteCurrency),
            SETTLEMENT_TIME_INTERVAL,
            NUMBER_OF_FRAGMENTS
        );

        baseCurrency.transferOwnership(deployer);
        quoteCurrency.transferOwnership(deployer);

        vm.stopBroadcast();

        return (deployer, baseCurrency, quoteCurrency, pair);
    }
}
