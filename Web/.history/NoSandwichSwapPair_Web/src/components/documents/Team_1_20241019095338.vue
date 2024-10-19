<!-- Introduction.vue -->
<template>
  <div class="intro-container">
    <h2>Artist Zhou</h2>
    <p><strong>President of ZJUBCA, INTJ</strong></p>
    <p>
      Chairman of the Zhejiang University Blockchain Association (currently pursuing an MBA), with a bachelor's degree in Computer Science and Finance, and currently involved in AI + Web3 entrepreneurship. He has 2 years of experience in quantitative trading (contributor at WorldQuant, 101 Alpha) and 3 years as a Supply Chain Director (@Yurun Holdings Group), where he was responsible for leading the research institute and managing over 100+ team members.
    </p>
    <p>
      At 15, he delivered a data report on mathematics and supply chain data analysis to Shanghai Jiaotong University and won the 2018 global runner-up in the Beijing-Dongguan World Supply Chain Challenge.
    </p>
    <p>
      In the Web3 field, he has organized events with support from the Ethereum Foundation in Hangzhou and represented China as a Solana Ambassador at the Holland Blockchain Conference. Additionally, he follows esports and served as a contract host and commentator for professional selection shows. In 2019, he was crowned the national champion in knife chess.
    </p>
    <p>Twitter: @Artistzhou</p>
  </div>
</template>

<script>
export default {
  name: 'Team_1',
};
</script>

<style scoped>
.content {
  color: aliceblue;
  background-color: #0c0c0e;
  margin: 0 auto;
  max-width: 80vw; /* 控制内容宽度，避免过宽 */
  box-sizing: border-box; /* 确保 padding 不会影响总宽度 */
  line-height: 1.6;
  height: 100%;
}
.content::-webkit-scrollbar {
  display: none; /* 对 Chrome、Safari 和 Edge 浏览器隐藏滚动条 */
}
h2, h3 {
  margin-bottom: 1.2rem;
  font-weight: bold;
}

h2{
  color: #168ddb;
}
h3{
  color:rgb(13, 87, 224)
}
p {
  margin-bottom: 1.5rem;
  font-size: 1.1rem;
}

ul {
  margin-bottom: 1.5rem;
}

li {
  margin-bottom: 0.8rem;
  line-height: 1.5;
}

ul li::marker {
  font-size: 1.2rem;
}
</style>
