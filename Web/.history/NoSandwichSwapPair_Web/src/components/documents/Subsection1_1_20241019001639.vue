<template>
  <div>
    <h2>概述</h2>
    <p>这是一个抗MEV的DEX，使用双曲集合竞价的方式，将一段时间内的若干笔交易加总后均匀交错排列，降低了单笔交易的价格冲击效应。</p>
    <ul>
      <li>减少价格冲击，让成交价贴近公允价格</li>
      <li>有效防范MEV攻击，使三明治攻击无利可图</li>
      <li>提高用户体验，减少滑点</li>
      <li>抑制价格波动性，减少LP的无常损失</li>
      <li>通过治理代币激励机制提高市场流动性</li>
    </ul>
  </div>
</template>

<script>
export default {
  name: 'Overview',
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
