// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "forge-std/Test.sol";
import "../src/NoSandwichSwapPair.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MockERC20 is ERC20 {
    constructor(
        string memory name_,
        string memory symbol_
    ) ERC20(name_, symbol_) {}

    function mint(address to, uint256 amount) external {
        _mint(to, amount);
    }
}

contract NoSandwichSwapPairTest is Test {
    NoSandwichSwapPair pair;
    MockERC20 baseToken;
    MockERC20 quoteToken;

    address alice = address(0x1);
    address bob = address(0x2);

    uint256 settlementTimeInterval = 60; // 1 hour
    uint256 numberOfFragments = 10;

    function setUp() public {
        // 部署模拟的 ERC20 代币
        baseToken = new MockERC20("Wuhan University", "WHU");
        quoteToken = new MockERC20(
            "Huangzhong University of Science and Technology",
            "HUST"
        );

        // 铸造代币给 Alice 和 Bob
        baseToken.mint(alice, 1000 ether);
        quoteToken.mint(alice, 1000 ether);
        baseToken.mint(bob, 1000 ether);
        quoteToken.mint(bob, 1000 ether);

        // 部署 NoSandwichSwapPair 合约
        pair = new NoSandwichSwapPair(
            address(baseToken),
            address(quoteToken),
            settlementTimeInterval,
            numberOfFragments
        );

        // Alice 和 Bob 授权合约使用他们的代币
        vm.startPrank(alice);
        baseToken.approve(address(pair), type(uint256).max);
        quoteToken.approve(address(pair), type(uint256).max);
        vm.stopPrank();

        vm.startPrank(bob);
        baseToken.approve(address(pair), type(uint256).max);
        quoteToken.approve(address(pair), type(uint256).max);
        vm.stopPrank();
    }

    function testInitialLiquidity() public {
        // 检查初始状态
        assertEq(pair.liquidity(), 0);
        assertEq(pair.baseCurrencyReserve(), 0);
        assertEq(pair.quoteCurrencyReserve(), 0);
    }

    function testAddInitialLiquidity() public {
        vm.startPrank(alice);

        uint256 baseAmount = 500 ether;
        uint256 quoteAmount = 500 ether;

        uint256 liquidityMinted = pair.addLiquidity(baseAmount, quoteAmount);

        // 计算预期的流动性
        uint256 expectedLiquidity = sqrt(baseAmount * quoteAmount);

        assertEq(liquidityMinted, expectedLiquidity);
        assertEq(pair.liquidity(), expectedLiquidity);
        assertEq(pair.liquidityBalance(alice), expectedLiquidity);
        assertEq(pair.baseCurrencyReserve(), baseAmount);
        assertEq(pair.quoteCurrencyReserve(), quoteAmount);
        assertEq(baseToken.balanceOf(alice), 1000 ether - baseAmount);
        assertEq(quoteToken.balanceOf(alice), 1000 ether - quoteAmount);

        vm.stopPrank();
    }

    function testAddSubsequentLiquidity() public {
        vm.startPrank(alice);
        // Alice 添加初始流动性
        uint256 baseAmountAlice = 500 ether;
        uint256 quoteAmountAlice = 500 ether;
        uint256 liquidityAlice = pair.addLiquidity(
            baseAmountAlice,
            quoteAmountAlice
        );
        vm.stopPrank();

        vm.startPrank(bob);
        // Bob 添加流动性
        uint256 baseAmountBob = 250 ether;
        uint256 quoteAmountBob = 250 ether;
        uint256 liquidityBob = pair.addLiquidity(baseAmountBob, quoteAmountBob);

        // 预期流动性增加量
        uint256 expectedLiquidityBob = (baseAmountBob * pair.liquidity()) /
            pair.baseCurrencyReserve();
        expectedLiquidityBob = expectedLiquidityBob <
            (quoteAmountBob * pair.liquidity()) / pair.quoteCurrencyReserve()
            ? expectedLiquidityBob
            : (quoteAmountBob * pair.liquidity()) / pair.quoteCurrencyReserve();

        assertEq(liquidityBob, expectedLiquidityBob);
        assertEq(pair.liquidity(), liquidityAlice + liquidityBob);
        assertEq(pair.liquidityBalance(bob), liquidityBob);
        assertEq(pair.baseCurrencyReserve(), baseAmountAlice + baseAmountBob);
        assertEq(
            pair.quoteCurrencyReserve(),
            quoteAmountAlice + quoteAmountBob
        );
        assertEq(baseToken.balanceOf(bob), 1000 ether - baseAmountBob);
        assertEq(quoteToken.balanceOf(bob), 1000 ether - quoteAmountBob);

        vm.stopPrank();
    }

    function testRemoveLiquidity() public {
        vm.startPrank(alice);
        // Alice 添加初始流动性
        uint256 baseAmount = 500 ether;
        uint256 quoteAmount = 500 ether;
        uint256 liquidityMinted = pair.addLiquidity(baseAmount, quoteAmount);
        vm.stopPrank();

        vm.startPrank(alice);
        // Alice 移除部分流动性
        uint256 liquidityToRemove = liquidityMinted / 2;
        (uint256 baseReturned, uint256 quoteReturned) = pair.removeLiquidity(
            liquidityToRemove
        );

        // 预期返回的代币数量
        uint256 expectedBase = (liquidityToRemove * baseAmount) /
            liquidityMinted;
        uint256 expectedQuote = (liquidityToRemove * quoteAmount) /
            liquidityMinted;

        assertEq(baseReturned, expectedBase);
        assertEq(quoteReturned, expectedQuote);
        assertEq(pair.liquidity(), liquidityMinted - liquidityToRemove);
        assertEq(pair.liquidityBalance(alice), liquidityToRemove);
        assertEq(pair.baseCurrencyReserve(), baseAmount - expectedBase);
        assertEq(pair.quoteCurrencyReserve(), quoteAmount - expectedQuote);
        assertEq(
            baseToken.balanceOf(alice),
            1000 ether - baseAmount + expectedBase
        );
        assertEq(
            quoteToken.balanceOf(alice),
            1000 ether - quoteAmount + expectedQuote
        );

        vm.stopPrank();
    }

    function testRemoveAllLiquidity() public {
        vm.startPrank(alice);
        // Alice 添加初始流动性
        uint256 baseAmount = 500 ether;
        uint256 quoteAmount = 500 ether;
        uint256 liquidityMinted = pair.addLiquidity(baseAmount, quoteAmount);

        // 移除所有流动性
        (uint256 baseReturned, uint256 quoteReturned) = pair.removeLiquidity(
            liquidityMinted
        );

        assertEq(baseReturned, baseAmount);
        assertEq(quoteReturned, quoteAmount);
        assertEq(pair.liquidity(), 0);
        assertEq(pair.liquidityBalance(alice), 0);
        assertEq(pair.baseCurrencyReserve(), 0);
        assertEq(pair.quoteCurrencyReserve(), 0);
        assertEq(baseToken.balanceOf(alice), 1000 ether);
        assertEq(quoteToken.balanceOf(alice), 1000 ether);

        vm.stopPrank();
    }

    function testAddLiquidityWithZeroAmount() public {
        vm.startPrank(alice);
        // 尝试添加流动性时传入零金额
        vm.expectRevert("Amounts must be greater than zero");
        pair.addLiquidity(0, 100 ether);
        vm.expectRevert("Amounts must be greater than zero");
        pair.addLiquidity(100 ether, 0);
        vm.stopPrank();
    }

    function testRemoveLiquidityInsufficientBalance() public {
        vm.startPrank(alice);
        // Alice 添加初始流动性
        uint256 baseAmount = 500 ether;
        uint256 quoteAmount = 500 ether;
        pair.addLiquidity(baseAmount, quoteAmount);

        // 尝试移除超过她拥有的流动性
        vm.expectRevert("Insufficient liquidity balance");
        pair.removeLiquidity(1000 ether);
        vm.stopPrank();
    }

    function testRemoveLiquidityWithZeroAmount() public {
        vm.startPrank(alice);
        // Alice 添加初始流动性
        uint256 baseAmount = 500 ether;
        uint256 quoteAmount = 500 ether;
        pair.addLiquidity(baseAmount, quoteAmount);

        // 尝试移除零流动性
        vm.expectRevert("Liquidity amount must be greater than zero");
        pair.removeLiquidity(0);
        vm.stopPrank();
    }

    // 辅助函数：计算平方根
    function sqrt(uint y) internal pure returns (uint z) {
        if (y > 3) {
            z = y;
            uint x = y / 2 + 1;
            while (x < z) {
                z = x;
                x = (y / x + x) / 2;
            }
        } else if (y != 0) {
            z = 1;
        }
    }
}
