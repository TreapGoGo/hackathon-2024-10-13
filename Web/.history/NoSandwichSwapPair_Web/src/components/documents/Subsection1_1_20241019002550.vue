<template>
  <div>
    <h2>What is AMM (自动做市商)</h2>
    <p>
      An Automated Market Maker (AMM) is a decentralized trading protocol that allows users to trade cryptocurrencies without the need for intermediaries. 
      In an AMM system, liquidity is provided by users who deposit two types of tokens into a liquidity pool, which generates a price curve for other users to trade against.
      Popular AMM protocols include Uniswap, Balancer, and SushiSwap.
      <br>
      自动做市商（AMM）是一种去中心化交易协议，允许交易者无需中介方进行加密货币的交换。AMM 系统中的流动性由用户提供，他们将两种代币存入流动性池，生成价格曲线，供其他用户交易。最著名的 AMM 协议有 Uniswap、Balancer 和 SushiSwap。
    </p>

    <h3>Benefits of AMM (AMM 的优点)</h3>
    <ul>
      <li>Fully automated without intermediaries or order books (无需中介或订单簿，完全自动化)</li>
      <li>Allows anyone to provide liquidity and participate in the market (允许任何人提供流动性，参与市场)</li>
      <li>Lowers the barriers to entry for trading (降低了交易的进入门槛)</li>
      <li>Increases market efficiency by constant liquidity provision (通过持续提供流动性，提高市场效率)</li>
    </ul>

    <h2>What is MEV (最大可提取价值)</h2>
    <p>
      Maximal Extractable Value (MEV) refers to the ability of miners or validators to reorder, insert, or remove transactions in a block to maximize their profit.
      One of the most common forms of MEV attacks is the sandwich attack, where attackers manipulate the market price by executing transactions before and after the target trade.
      <br>
      最大可提取价值（MEV）指的是矿工或验证者通过重新排序、插入或移除区块中的交易，最大化其利润的能力。MEV 攻击最常见的一种形式是三明治攻击，攻击者通过在目标交易之前和之后各发起一笔交易，操纵市场价格，从而获利。
    </p>

    <h3>Impact of MEV Attacks (MEV 攻击的影响)</h3>
    <p>
      MEV attacks can harm regular traders by artificially inflating transaction costs and causing price volatility. In response to these attacks, many decentralized exchanges are developing new mechanisms to mitigate the impact of MEV, such as batch trading and auction mechanisms.
      <br>
      MEV 攻击会对普通交易者造成损害，因为它会人为地提高交易费用并引起价格波动。为了应对这些攻击，许多去中心化交易平台正在开发新的机制来减轻 MEV 的影响，例如批量交易、集合竞价等。
    </p>

    <h3>Solutions to MEV (应对 MEV 的解决方案)</h3>
    <ul>
      <li>Batch trading to aggregate and execute multiple transactions at once (批量交易来聚合并同时执行多笔交易)</li>
      <li>Auction-based mechanisms to ensure fair order execution (基于拍卖机制确保公平的订单执行)</li>
      <li>Researching zero-knowledge proofs to hide transaction details (研究零知识证明以隐藏交易细节)</li>
    </ul>
  </div>
</template>

<script>
export default {
  name: 'GeneralConcepts',
};
</script>

<style scoped>
div {
  color: aliceblue;
  background-color: #0c0c0e;
  padding: 2vw;
  margin: 2vh;
}
</style>
