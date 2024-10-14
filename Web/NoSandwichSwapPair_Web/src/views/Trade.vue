<template>
  <div class="container">
    <div class="chart-container">
      <div ref="chart" style="width: 100%; height: 100%;"></div>
    </div>
    <div class="trade-container">
      <h2>buy or sell</h2>
      <div class="trade-operations">
        <label for="quantity">Amount:</label>
        <input v-model="quantity" type="number" id="quantity" min="1" />
        <button @click="buy" class="buy-button">buy Token X</button>
        <button @click="sell" class="sell-button">Sell Token X</button>
        <button @click="togglePriceSource" class="test-button">
          {{ useRandomPrice ? 'Switch to Contract Price' : 'Switch to Random Price' }}
</button>

      </div>
    </div>
  </div>
</template>

<style scoped>
  @font-face {
    font-family: 'Montserrat';
    src: url('../assets/fonts/Montserrat/Montserrat-Italic-VariableFont_wght.ttf') format('truetype');
    font-weight: normal;
    font-style: normal;
  }
  *{
    font-family: Montserrat;
    font-weight: bold;
  }
  .container {
    display: flex;
    justify-content: space-between;
    width: 100%;
    height: 100vh;
    padding: 2rem;
    background-color: #0a0a0a;
  }

  .chart-container {
    flex: 2;
    margin-right: 2rem;
    background-color: #1e1e1e;
    margin-top: 15vh;
    border-radius: 8px;
    padding: 1rem;
    height: 70vh;
  }

  .trade-container {
    flex: 1;
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
    background-color: #0a0a0a;
    border-radius: 8px;
    box-shadow: 0 0 20px rgba(0, 0, 0, 0.5);
    color: #e0e0ff;
    padding: 1.5rem;
    height: 85vh;
  }

  h2 {
    text-align: center;
    margin-bottom: 2rem;
    color: #b8a1ff;
    text-shadow: 0 2px 4px rgba(0, 0, 0, 0.3);
  }

  .trade-operations {
    display: flex;
    flex-direction: column;
    align-items: center;
    width: 100%;
  }

  label {
    display: block;
    margin-bottom: 1rem;
    color: #e0e0ff;
  }

  input[type="number"] {
    width: 100px;
    padding: 0.5rem;
    font-size: 16px;
    margin-bottom: 2rem;
    background-color: #302b63;
    color: #fff;
    border: none;
    border-radius: 4px;
    box-shadow: 0 0 10px rgba(50, 50, 100, 0.5);
  }

  button {
    width: 100%;
    max-width: 200px;
    padding: 1rem;
    font-size: 16px;
    cursor: pointer;
    margin-bottom: 1.5rem;
    border: none;
    border-radius: 4px;
    color: #fff;
    transition: transform 0.2s ease-in-out, box-shadow 0.2s ease-in-out;
  }

  .buy-button {
    background-color: #6f42c1;
    box-shadow: 0 0 10px rgba(111, 66, 193, 0.7);
  }

  .sell-button {
    background-color: #ff7675;
    box-shadow: 0 0 10px rgba(255, 118, 117, 0.7);
  }

  .test-button{
    background-color: #20d891;
    box-shadow: 0 0 10px rgba(38, 156, 58, 0.7);
  }
  button:hover {
    transform: scale(1.05);
    box-shadow: 0 0 15px rgba(111, 66, 193, 0.9);
  }

  .current-price {
    margin-top: 2rem;
    color: #00eaff;
  }
</style>

<script>
import * as echarts from 'echarts';
import Web3 from 'web3';
import { mapState } from 'vuex';

export default {
  name: "TradingLineChart",
  data() {
    return {
      chart: null,
      timer: null,
      timeRange: 1, // 时间范围，单位为分钟
      updateInterval: 1000, // 更新间隔时间，单位为毫秒
      data: [], // 图表数据
      quantity: 1, // 默认交易数量
      price: null, // 当前价格，从合约获取
      contract: null, // 智能合约对象
      web3: null, // Web3对象
      contractAddress: '0xYourContractAddressHere', // 你的智能合约地址
      tokenx_address: '0xYourContractAddress2945', // x的地址
      tokeny_address: '0xYourContractAddress1354', // y的地址
      useRandomPrice: false, // 控制是否使用随机价格
      contractABI: [
    {
        "constant": true,
        "inputs": [],
        "name": "getPrice",
        "outputs": [
            {
                "internalType": "uint256",
                "name": "",
                "type": "uint256"
            }
        ],
        "payable": false,
        "stateMutability": "view",
        "type": "function"
    },
    {
        "constant": false,
        "inputs": [
            {
                "internalType": "address",
                "name": "tokenAddress",
                "type": "address"
            },
            {
                "internalType": "uint256",
                "name": "amountIn",
                "type": "uint256"
            }
        ],
        "name": "addSwapTransaction",
        "outputs": [],
        "payable": false,
        "stateMutability": "nonpayable",
        "type": "function"
    }
]

    };
  },
  computed: {
    // 使用 mapState 从 Vuex Store 中获取钱包地址和连接状态
    ...mapState({
      walletAddress: state => state.walletAddress,
      isConnected: state => state.isConnected,
    }),
  },
  methods: {
    generateTimeLabels() {
      const now = new Date();
      const timeLabels = [];
  
      for (let i = this.timeRange * 60; i >= 0; i--) {
        const pastTime = new Date(now.getTime() - i * 1000);
        const hours = pastTime.getHours().toString().padStart(2, '0');
        const minutes = pastTime.getMinutes().toString().padStart(2, '0');
        const seconds = pastTime.getSeconds().toString().padStart(2, '0');
        timeLabels.push(`${hours}:${minutes}:${seconds}`);
      }
  
      return timeLabels;
    },
    async initWeb3() {
      if (window.ethereum) {
        this.web3 = new Web3(window.ethereum);

        try {
          await window.ethereum.request({ method: 'eth_requestAccounts' });

          this.contract = new this.web3.eth.Contract(this.contractABI, this.contractAddress);

          console.log('合约已成功初始化');
        } catch (error) {
          console.error('用户拒绝访问钱包或合约初始化失败', error);
        }
      } else {
        alert('请安装MetaMask');
      }
    },
    initChart() {
      const chartDom = this.$refs.chart;
      this.chart = echarts.init(chartDom);

      this.data = new Array(this.timeRange * 60 + 1).fill(0);

      const option = {
        backgroundColor: '#000',
        title: {
          text: 'Trading line charts',
          textStyle: {
            color: '#00eaff',
            fontSize: 24,
            fontWeight: 'bold',
          },
          left: 'center',
          top: 10,
        },
        tooltip: {
          trigger: 'axis',
          textStyle: {
            color: '#fff',
          },
        },
        xAxis: {
          type: 'category',
          data: this.generateTimeLabels(),
          axisLine: {
            lineStyle: {
              color: '#00eaff', // x轴线颜色
            },
          },
          axisLabel: {
            color: '#00eaff', // x轴标签颜色
          },
        },
        yAxis: {
          type: 'value',
          axisLine: {
            lineStyle: {
              color: '#00eaff', // y轴线颜色
            },
          },
          splitLine: {
            lineStyle: {
              color: '#333', // 网格线颜色
            },
          },
          axisLabel: {
            color: '#00eaff', // y轴标签颜色
          },
        },
        series: [
          {
            name: '交易额',
            type: 'line',
            data: this.data,
            smooth: true,
            lineStyle: {
              color: {
                type: 'linear',
                x: 0,
                y: 0,
                x2: 1,
                y2: 0,
                colorStops: [
                  { offset: 0, color: '#ff7c7c' }, // 渐变色起始
                  { offset: 1, color: '#007fff' }, // 渐变色结束
                ],
              },
              width: 3,
            },
            areaStyle: {
              color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
                { offset: 0, color: 'rgba(0, 255, 255, 0.4)' },
                { offset: 1, color: 'rgba(0, 0, 0, 0)' },
              ]),
            },
            symbol: 'circle',
            symbolSize: 8,
            itemStyle: {
              color: '#00eaff',
              borderColor: '#fff',
              borderWidth: 2,
            },
          },
        ],
        animationEasing: 'cubicOut',
        animationDuration: 2000,
      };

      this.chart.setOption(option);
    },

    // 获取合约的当前价格
    async fetchPriceFromContract() {
  try {
    if (this.useRandomPrice) {
      // 使用随机价格
      const randomPrice = (Math.random() * (200 - 100) + 100).toFixed(2);
      this.price = randomPrice;
      console.log('随机生成的价格:', this.price);
    } else {
      // 获取合约中的价格
      const priceFromContract = await this.contract.methods.getPrice().call();
      this.price = this.web3.utils.fromWei(priceFromContract, 'ether'); // 假设价格是以wei为单位
    }
  } catch (error) {
    this.price =0
    console.error('获取价格失败', error);
  }
},
togglePriceSource() {
    this.useRandomPrice = !this.useRandomPrice;
  },
    async swap(tokenAddress, amountIn) {
      try {
        await contract.methods.addSwapTransaction(tokenAddress, amountIn).send({from: walletAddress});
    console.log("交易成功");
  } catch (error) {
    console.error("交易失败:", error);
  }
},
async buy() {
  if (!this.isConnected) {
    alert('请先连接钱包');
    return;
  }

  try {
    const amountToBuy = this.quantity;

    // 调用 swap 函数，传入 tokenX_address (使用 X 购买 Y)
    await this.swap(this.tokenx_address, amountToBuy);
  } catch (error) {
    console.error('买入失败', error);
  }
},
async sell() {
  if (!this.isConnected) {
    alert('请先连接钱包');
    return;
  }

  try {
    const amountToSell = this.quantity;
    await this.swap(this.tokeny_address, amountToSell);

  } catch (error) {
    console.error('卖出失败', error);
  }
},
    updateChart() {
      this.fetchPriceFromContract().then(() => {
        this.data.push(parseFloat(this.price)); // 将新的价格加入数据数组
        this.data.shift(); // 移除最早的一个数据
        const newTimeLabels = this.generateTimeLabels();
        this.chart.setOption({
          xAxis: {
            data: newTimeLabels, // 更新时间轴
          },
          series: [
            {
              data: this.data, // 更新图表数据
            },
          ],
        });
      });
    },
  },

  mounted() {
    this.initWeb3();
    this.initChart();

    this.timer = setInterval(() => {
      this.updateChart(); // 每次获取新价格并更新图表
    }, this.updateInterval);
  },

  beforeDestroy() {
    if (this.chart) {
      this.chart.dispose();
    }
    if (this.timer) {
      clearInterval(this.timer);
    }
  },
};
</script>
