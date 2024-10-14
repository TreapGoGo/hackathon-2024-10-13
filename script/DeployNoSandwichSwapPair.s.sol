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
        uint256 deployerKey = helperConfig.activeNetworkConfig();
        address deployer = getDeployerAddress(deployerKey);

        vm.startBroadcast(deployerKey);

        baseCurrency = new MyERC20Mock("Base", "BASE", deployer);
        quoteCurrency = new MyERC20Mock("Quote", "QUOTE", deployer);

        baseCurrency.mint(deployer, 10000);
        quoteCurrency.mint(deployer, 10000);

        pair = new NoSandwichSwapPair(
            address(baseCurrency),
            address(quoteCurrency),
            SETTLEMENT_TIME_INTERVAL,
            NUMBER_OF_FRAGMENTS
        );

        baseCurrency.transferOwnership(deployer);
        quoteCurrency.transferOwnership(deployer);

        return (deployer, baseCurrency, quoteCurrency, pair);
    }

    function getDeployerAddress(
        uint256 privateKey
    ) public pure returns (address) {
        // 通过私钥计算公钥
        // elliptic curve multiplication (ECM) 来生成公钥
        // ecrecover 不能直接生成公钥，但通过调用预编译合约可以实现。

        // 调用以太坊预编译合约 0x04
        bytes32 hash = keccak256(abi.encodePacked(privateKey));
        address deployer = address(uint160(uint256(hash)));

        return deployer;
    }
}
