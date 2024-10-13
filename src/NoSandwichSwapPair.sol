// SPDX-License-Identifier: MIT

pragma solidity ^0.8.28;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract NoSandwichSwapPair {
    // State Variables
    address immutable i_baseCurrencyAddress;
    address immutable i_quoteCurrencyAddress;
    IERC20 immutable i_baseCurrencyContract;
    IERC20 immutable i_quoteCurrencyContract;

    uint256 public i_settlementTimeInterval; // unit: second
    uint256 public i_numberOfFragments;

    address[] public baseCurrencyContributors;
    mapping(address => uint256) baseCurrencyContributions;
    address[] public quoteCurrencyContributors;
    mapping(address => uint256) quoteCurrencyContributions;
    uint256 lastSettlementTimestamp;

    // Events

    // Errors

    // Modifiers

    modifier checkIfThisIsTheFirstSwapCall() {
        if (lastSettlementTimestamp == 0) {
            lastSettlementTimestamp = block.timestamp;
        }
        _;
    }

    modifier checkWhetherToTriggerSettlement() {
        // To do
        _;
    }

    // Constructor
    constructor(
        address baseCurrencyAddress,
        address quoteCurrencyAddress,
        uint256 settlementTimeInterval,
        uint256 numberOfFragments
    ) {
        i_baseCurrencyAddress = baseCurrencyAddress;
        i_quoteCurrencyAddress = quoteCurrencyAddress;
        i_baseCurrencyContract = IERC20(i_baseCurrencyAddress);
        i_quoteCurrencyContract = IERC20(i_quoteCurrencyAddress);

        i_settlementTimeInterval = settlementTimeInterval;
        i_numberOfFragments = numberOfFragments;

        lastSettlementTimestamp = 0;
    }

    // External / Public Functions

    function addLiquidity(
        uint256 baseCurrencyAmount,
        uint256 quoteCurrencyAmount
    ) external returns (uint256 liquidityMinted) {
        require(
            amount1 > 0 && amount2 > 0,
            "Amounts must be greater than zero"
        );

        // 将代币转入合约
        require(
            token1.transferFrom(msg.sender, address(this), amount1),
            "Transfer token1 failed"
        );
        require(
            token2.transferFrom(msg.sender, address(this), amount2),
            "Transfer token2 failed"
        );
    }

    function removeLiquidity() external {}

    function addSwapTransaction() external {}

    function settleAndDistribution() internal {}

    // Pure / View Functions
}
