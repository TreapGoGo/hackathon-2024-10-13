<template>
  <div>
    <h2>原理</h2>
    <p>设期初流动性池满足 \( x_0 \times y_0 = k \) 。对于每一个结算周期，流动性池收到的基准货币和计价货币数量分别为：</p>
    <p>\( \{a_1, a_2, ..., a_A\}, \{b_1, b_2, ..., b_B\} \)</p>
    <p>然后将这些交易均匀排列，以摊平价格冲击。</p>
  </div>
</template>

<script>
export default {
  name: 'Principle',
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
