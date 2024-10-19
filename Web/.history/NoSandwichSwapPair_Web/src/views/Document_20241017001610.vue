<template>
    <div class="documentation-page">
      <!-- 左侧折叠导航栏 -->
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
  
      <!-- 右侧内容展示 -->
      <main class="content">
        <!-- 使用 v-html 渲染自定义的 HTML 格式 -->
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
  