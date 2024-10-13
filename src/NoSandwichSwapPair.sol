// SPDX-License-Identifier: MIT

pragma solidity ^0.8.28;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import {SandwichToken} from "./SandwichToken.sol";

contract NoSandwichSwapPair is ReentrancyGuard {
    // State Variables
    address immutable i_baseCurrencyAddress;
    address immutable i_quoteCurrencyAddress;
    IERC20 immutable i_baseCurrencyContract;
    IERC20 immutable i_quoteCurrencyContract;

    uint256 public i_settlementTimeInterval; // unit: second
    uint256 public i_numberOfFragments;

    uint256 public baseCurrencyReserve;
    uint256 public quoteCurrencyReserve;
    uint256 public liquidity;
    mapping(address => uint256) public liquidityBalance;

    address[] public baseCurrencyContributors;
    mapping(address => uint256) baseCurrencyContributions;
    address[] public quoteCurrencyContributors;
    mapping(address => uint256) quoteCurrencyContributions;
    uint256 lastSettlementTimestamp;

    SandwichToken public sandwichToken;

    // Events
    event LiquidityAdded(address indexed provider, uint256 baseAmount, uint256 quoteAmount, uint256 liquidityMinted);

    event LiquidityRemoved(address indexed provider, uint256 baseAmount, uint256 quoteAmount, uint256 liquidityBurned);

    event SwapTransactionAdded(address indexed user, address indexed token, uint256 amountIn);

    event SettlementPerformed(uint256 baseOut, uint256 quoteOut, uint256 timestamp);

    // Errors
    error AmountsMustBeGreaterThanZero();
    error TransferBaseCurrencyFailed();
    error TransferQuoteCurrencyFailed();
    error LiquidityAmountMustBeGreaterThanZero();
    error InsufficientLiquidityBalance();
    error InvalidToken();
    error TransferFailed();
    error SettlementIntervalNotElapsed();
    error BalanceCheckFailed();

    // Modifiers

    modifier checkIfThisIsTheFirstSwapCall() {
        if (lastSettlementTimestamp == 0) {
            lastSettlementTimestamp = block.timestamp;
        }
        _;
    }

    modifier checkWhetherToTriggerSettlement() {
        _;
        if (block.timestamp - lastSettlementTimestamp >= i_settlementTimeInterval) {
            settleAndDistribution();
        }
    }

    // Constructor
    constructor(
        address _baseCurrencyAddress,
        address _quoteCurrencyAddress,
        uint256 _settlementTimeInterval,
        uint256 _numberOfFragments
    ) {
        i_baseCurrencyAddress = _baseCurrencyAddress;
        i_quoteCurrencyAddress = _quoteCurrencyAddress;
        i_baseCurrencyContract = IERC20(i_baseCurrencyAddress);
        i_quoteCurrencyContract = IERC20(i_quoteCurrencyAddress);

        i_settlementTimeInterval = _settlementTimeInterval;
        i_numberOfFragments = _numberOfFragments;

        lastSettlementTimestamp = 0;
        liquidity = 0;

        sandwichToken = new SandwichToken(address(this), 1 days, 1000 ether);
    }

    // External / Public Functions

    function addLiquidity(uint256 baseCurrencyAmount, uint256 quoteCurrencyAmount)
        external
        nonReentrant
        returns (uint256 liquidityMinted)
    {
        if (baseCurrencyAmount == 0 || quoteCurrencyAmount == 0) {
            revert AmountsMustBeGreaterThanZero();
        }

        // Transfer tokens to the contract
        bool baseTransfer = i_baseCurrencyContract.transferFrom(msg.sender, address(this), baseCurrencyAmount);
        if (!baseTransfer) {
            revert TransferBaseCurrencyFailed();
        }

        bool quoteTransfer = i_quoteCurrencyContract.transferFrom(msg.sender, address(this), quoteCurrencyAmount);
        if (!quoteTransfer) {
            revert TransferQuoteCurrencyFailed();
        }

        if (liquidity == 0) {
            liquidity = sqrt(baseCurrencyAmount * quoteCurrencyAmount);
            liquidityMinted = liquidity;
            liquidityBalance[msg.sender] = liquidity;
        } else {
            uint256 liquidity1 = (baseCurrencyAmount * liquidity) / baseCurrencyReserve;
            uint256 liquidity2 = (quoteCurrencyAmount * liquidity) / quoteCurrencyReserve;
            liquidityMinted = liquidity1 < liquidity2 ? liquidity1 : liquidity2;
            liquidity += liquidityMinted;
            liquidityBalance[msg.sender] += liquidityMinted;
        }

        baseCurrencyReserve += baseCurrencyAmount;
        quoteCurrencyReserve += quoteCurrencyAmount;

        emit LiquidityAdded(msg.sender, baseCurrencyAmount, quoteCurrencyAmount, liquidityMinted);
    }

    function removeLiquidity(uint256 liquidityAmount)
        external
        nonReentrant
        returns (uint256 baseAmount, uint256 quoteAmount)
    {
        if (liquidityAmount == 0) {
            revert LiquidityAmountMustBeGreaterThanZero();
        }
        if (liquidityBalance[msg.sender] < liquidityAmount) {
            revert InsufficientLiquidityBalance();
        }

        // Calculate amounts to return to the user
        baseAmount = (liquidityAmount * baseCurrencyReserve) / liquidity;
        quoteAmount = (liquidityAmount * quoteCurrencyReserve) / liquidity;

        // Update total liquidity and user's liquidity balance
        liquidity -= liquidityAmount;
        liquidityBalance[msg.sender] -= liquidityAmount;

        // Update reserves
        baseCurrencyReserve -= baseAmount;
        quoteCurrencyReserve -= quoteAmount;

        // Transfer tokens back to the user
        bool baseTransfer = i_baseCurrencyContract.transfer(msg.sender, baseAmount);
        if (!baseTransfer) {
            revert TransferBaseCurrencyFailed();
        }

        bool quoteTransfer = i_quoteCurrencyContract.transfer(msg.sender, quoteAmount);
        if (!quoteTransfer) {
            revert TransferQuoteCurrencyFailed();
        }

        emit LiquidityRemoved(msg.sender, baseAmount, quoteAmount, liquidityAmount);

        return (baseAmount, quoteAmount);
    }

    function addSwapTransaction(address tokenAddress, uint256 amountIn)
        external
        nonReentrant
        checkIfThisIsTheFirstSwapCall
        checkWhetherToTriggerSettlement
    {
        if (tokenAddress != i_baseCurrencyAddress && tokenAddress != i_quoteCurrencyAddress) {
            revert InvalidToken();
        }
        if (amountIn == 0) {
            revert AmountsMustBeGreaterThanZero();
        }

        if (tokenAddress == i_baseCurrencyAddress) {
            bool transfer = i_baseCurrencyContract.transferFrom(msg.sender, address(this), amountIn);
            if (!transfer) {
                revert TransferFailed();
            }
            baseCurrencyContributors.push(msg.sender);
            baseCurrencyContributions[msg.sender] += amountIn;
        } else {
            bool transfer = i_quoteCurrencyContract.transferFrom(msg.sender, address(this), amountIn);
            if (!transfer) {
                revert TransferFailed();
            }
            quoteCurrencyContributors.push(msg.sender);
            quoteCurrencyContributions[msg.sender] += amountIn;
        }

        emit SwapTransactionAdded(msg.sender, tokenAddress, amountIn);
    }

    function settleAndDistribution() internal {
        // Recheck whether settlement interval has elapsed
        if ((block.timestamp - lastSettlementTimestamp) < i_settlementTimeInterval) {
            revert SettlementIntervalNotElapsed();
        }

        // Sum of all base and quote contributions in this period
        uint256 alpha = 0;
        uint256 beta = 0;
        for (uint256 i = 0; i < baseCurrencyContributors.length; i++) {
            alpha += baseCurrencyContributions[baseCurrencyContributors[i]];
        }
        for (uint256 i = 0; i < quoteCurrencyContributors.length; i++) {
            beta += quoteCurrencyContributions[quoteCurrencyContributors[i]];
        }

        // Temporary reserves to save gas
        uint256 temporaryBaseCurrencyReserve = baseCurrencyReserve;
        uint256 temporaryQuoteCurrencyReserve = quoteCurrencyReserve;
        uint256 constantProductK = getConstantProduct();

        // Divide the sum of transactions equally and arrange them evenly
        for (uint256 i = 1; i <= i_numberOfFragments; i++) {
            // Base currency increase and quote currency decrease
            temporaryBaseCurrencyReserve += alpha / i_numberOfFragments;
            temporaryQuoteCurrencyReserve = constantProductK / temporaryBaseCurrencyReserve;

            // Quote currency increase and base currency decrease
            temporaryQuoteCurrencyReserve += beta / i_numberOfFragments;
            temporaryBaseCurrencyReserve = constantProductK / temporaryQuoteCurrencyReserve;

            // NOTE: This algorithm is only asymptotically unbiased,
            // because the increase of base currency always goes first.
            // If we want to make it completely unbiased, we should
            // simulate in another direction and calculate the mean value.
        }

        // Calculate the output
        uint256 BaseCurrencyOut = baseCurrencyReserve + alpha - temporaryBaseCurrencyReserve;
        uint256 QuoteCurrencyOut = quoteCurrencyReserve + beta - temporaryQuoteCurrencyReserve;

        // Distribute
        for (uint256 i = 0; i < baseCurrencyContributors.length; i++) {
            uint256 contribution = baseCurrencyContributions[baseCurrencyContributors[i]];
            uint256 payout = (QuoteCurrencyOut * contribution) / alpha;
            bool transfer = i_quoteCurrencyContract.transfer(baseCurrencyContributors[i], payout);
            if (!transfer) {
                revert TransferFailed();
            }
        }
        for (uint256 i = 0; i < quoteCurrencyContributors.length; i++) {
            uint256 contribution = quoteCurrencyContributions[quoteCurrencyContributors[i]];
            uint256 payout = (BaseCurrencyOut * contribution) / beta;
            bool transfer = i_baseCurrencyContract.transfer(quoteCurrencyContributors[i], payout);
            if (!transfer) {
                revert TransferFailed();
            }
        }

        // Update the reserves
        baseCurrencyReserve = temporaryBaseCurrencyReserve;
        quoteCurrencyReserve = temporaryQuoteCurrencyReserve;

        if (baseCurrencyReserve != i_baseCurrencyContract.balanceOf(address(this))) {
            revert BalanceCheckFailed();
        }
        if (quoteCurrencyReserve != i_quoteCurrencyContract.balanceOf(address(this))) {
            revert BalanceCheckFailed();
        }

        // Reset for the next settlement period
        lastSettlementTimestamp = block.timestamp;
        for (uint256 i = 0; i < baseCurrencyContributors.length; i++) {
            baseCurrencyContributions[baseCurrencyContributors[i]] = 0;
        }
        for (uint256 i = 0; i < quoteCurrencyContributors.length; i++) {
            quoteCurrencyContributions[quoteCurrencyContributors[i]] = 0;
        }
        baseCurrencyContributors = new address[](0);
        quoteCurrencyContributors = new address[](0);

        // mint SANDWICH for the trader who triggered settlement and paid extra gas
        sandwichToken.mint(tx.origin);

        emit SettlementPerformed(BaseCurrencyOut, QuoteCurrencyOut, block.timestamp);
    }

    // Pure / View Functions

    function sqrt(uint256 y) internal pure returns (uint256 z) {
        if (y > 3) {
            z = y;
            uint256 x = y / 2 + 1;
            while (x < z) {
                z = x;
                x = (y / x + x) / 2;
            }
        } else if (y != 0) {
            z = 1;
        }
    }

    function getConstantProduct() public view returns (uint256) {
        return baseCurrencyReserve * quoteCurrencyReserve;
    }
}
