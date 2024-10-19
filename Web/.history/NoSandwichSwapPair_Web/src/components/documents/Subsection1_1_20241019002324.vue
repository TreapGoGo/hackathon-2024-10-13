<template>
  <div>
    <h2>什么是 AMM 和 MEV</h2>
    <p>自动做市商（AMM）是一种去中心化交易协议，允许交易者无需中介方进行加密货币的交换。AMM 系统中的流动性是由用户提供的，他们将两种代币存入流动性池，生成价格曲线，以此供其他用户交易。最著名的 AMM 协议有 Uniswap、Balancer 和 SushiSwap。</p>
    
    <p>最大可提取价值（MEV）指的是矿工或验证者通过重新排序、插入或移除区块中的交易，最大化其利润的能力。MEV 攻击最常见的一种形式是三明治攻击，攻击者通过在目标交易之前和之后各发起一笔交易，操纵市场价格，从而获利。</p>

    <h3>AMM 的优点</h3>
    <ul>
      <li>无需中介或订单簿，完全自动化</li>
      <li>允许任何人提供流动性，参与市场</li>
      <li>降低了交易的进入门槛</li>
    </ul>

    <h3>MEV 攻击的影响</h3>
    <p>MEV 攻击会对普通交易者造成损害，因为它会人为地提高交易费用并引起价格波动。为了应对这些攻击，许多去中心化交易平台正在开发新的机制来减轻 MEV 的影响，例如批量交易、集合竞价等。</p>
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
