<template>
    <div class="documentation-page">
      <aside class="sidebar">
        <ul>
          <li v-for="(item, index) in menuItems" :key="index">
            <div @click="toggleSection(index)">
              {{ item.title }}
              <span v-if="item.isOpen">▲</span>
              <span v-else>▼</span>
            </div>
            <ul v-show="item.isOpen">
              <li v-for="(subItem, subIndex) in item.sections" :key="subIndex">
                <a href="#" @click="showContent(subItem)">{{ subItem.name }}</a>
              </li>
            </ul>
          </li>
        </ul>
      </aside>
  
      <main class="content">
        <section v-if="selectedSection">
          <div v-html="selectedSection.content"></div>
        </section>
        <section v-else>
          <p>Please select a section from the menu</p>
        </section>
      </main>
    </div>
  </template>
  
  <script>
  export default {
    data() {
      return {
        menuItems: [
          {
            title: 'Section 1',
            isOpen: false,
            sections: [
              { name: 'Subsection 1.1', content: '<h2>Subsection 1.1</h2><p>Custom HTML content for subsection 1.1</p>' },
              { name: 'Subsection 1.2', content: '<h2>Subsection 1.2</h2><p>Custom HTML content for subsection 1.2</p>' },
            ],
          },
          {
            title: 'Section 2',
            isOpen: false,
            sections: [
              { name: 'Subsection 2.1', content: '<h2>Subsection 2.1</h2><p>Custom HTML content for subsection 2.1</p>' },
              { name: 'Subsection 2.2', content: '<h2>Subsection 2.2</h2><p>Custom HTML content for subsection 2.2</p>' },
            ],
          }, 
          {
            title: 'Section 3',
            isOpen: false,
            sections: [
              { name: 'Subsection 3.1', content: '<h2>Subsection 3.1</h2><p>Custom HTML content for subsection 3.1</p>' },
              { name: 'Subsection 3.2', content: '<h2>Subsection 3.2</h2><p>Custom HTML content for subsection 3.2</p>' },
            ],
          },
        ],
        selectedSection: null,
      };
    },
    methods: {
      toggleSection(index) {
        this.menuItems[index].isOpen = !this.menuItems[index].isOpen;
      },
      showContent(subItem) {
        this.selectedSection = subItem;
      },
    },
  };
  </script>
  <style scoped>
  /* 黑暗模式+蓝紫调配色 */
  .documentation-page {
    display: flex;
    min-height: 100vh;
    top:20vh;
    background-color: #1e1e2f; /* 深色背景 */
    color: #c9d1d9; /* 较亮的文字颜色 */
    position: relative;
  }
  
  .sidebar {
    width: 250px;
    background-color: #2a2a40; /* 左侧导航栏的深色背景 */
    padding: 20px;
    box-shadow: 2px 0 5px rgba(0, 0, 0, 0.3);
    position: sticky;
    top: 0;
    height: 100vh;
    overflow-y: auto;
  }
  
  .sidebar ul {
    list-style-type: none;
    padding: 0;
  }
  
  .sidebar li {
    margin-bottom: 10px;
  }
  
  .sidebar li > div {
    cursor: pointer;
    font-weight: bold;
    color: #6f77ff; /* 蓝紫色调 */
    margin-bottom: 5px;
  }
  
  .sidebar ul ul {
    padding-left: 20px;
  }
  
  .sidebar a {
    text-decoration: none;
    color: #a0a8ff; /* 子菜单的蓝紫色 */
    display: block;
    margin: 5px 0;
  }
  
  .sidebar a:hover {
    color: #ffffff; /* 悬停时更亮 */
  }
  
  .content {
    flex-grow: 1;
    padding: 20px;
    background-color: #232334; /* 右侧内容的背景 */
    box-shadow: inset 0 0 10px rgba(0, 0, 0, 0.5);
  }
  
  /* 层次结构：标题和分割线样式 */
  .content section {
    margin-bottom: 40px;
  }
  
  h2 {
    color: #8a92ff; /* 蓝紫色标题 */
    border-bottom: 2px solid #6f77ff; /* 分割线 */
    padding-bottom: 10px;
  }
  
  h3 {
    color: #a0a8ff; /* 次级标题 */
    margin-top: 20px;
  }
  
  h4 {
    color: #c9d1d9; /* 更深一级标题 */
    margin-top: 15px;
  }
  
  p {
    margin-bottom: 15px;
  }
  
  hr {
    border: none;
    border-top: 1px solid #6f77ff; /* 蓝紫色分割线 */
    margin: 20px 0;
  }
  </style>
  