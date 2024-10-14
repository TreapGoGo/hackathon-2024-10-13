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
        <button @click="buy" class="buy-button">buy</button>
        <button @click="sell" class="sell-button">Sell</button>
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
  padding: 2rem; /* 适当的外边距让内容不至于紧贴边缘 */
  background-color: #0a0a0a;
}

.chart-container {
  flex: 2;
  margin-right: 2rem; /* 使图表和右侧交易区域有适当的间距 */
  background-color: #1e1e1e;
  margin-top: 15vh;
  border-radius: 8px;
  padding: 1rem; /* 给图表区域适当内边距 */
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
  height: 85vh; /* 保持和左侧高度一致 */
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
  max-width: 200px; /* 限制按钮最大宽度 */
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

button:hover {
  transform: scale(1.05);
  box-shadow: 0 0 15px rgba(111, 66, 193, 0.9);
}


  </style>
  <script>
  import * as echarts from 'echarts';
  
  export default {
    name: "TradingLineChart",
    data() {
      return {
        chart: null,
        timer: null,
        timeRange: 10,
        updateInterval: 5000,
        data: [],
        quantity: 1, // 默认交易数量
      };
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
          animationDuration: 2000, // 动画效果
        };
  
        this.chart.setOption(option);
      },
  
      updateChart() {
        const newTransactionAmount = Math.floor(Math.random() * 100); // 模拟数据
  
        // 更新数据：移除最早的一个数据，增加最新的数据
        this.data.shift();
        this.data.push(newTransactionAmount);
  
        const newTimeLabels = this.generateTimeLabels();

        this.chart.setOption({
          xAxis: {
            data: newTimeLabels, // 更新时间轴
          },
          series: [
            {
              data: this.data, // 更新交易额数据
            },
          ],
        });
      },
  
      buy() {
        alert(`买入 ${this.quantity} 单位`);
        // 在这里添加买入的逻辑
      },
  
      sell() {
        alert(`卖出 ${this.quantity} 单位`);
        // 在这里添加卖出的逻辑
      },
    },
    mounted() {
      this.initChart();

      this.timer = setInterval(() => {
        this.updateChart();
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