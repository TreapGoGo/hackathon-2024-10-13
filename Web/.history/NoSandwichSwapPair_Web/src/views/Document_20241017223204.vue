<template>
  <div class="documentation-page">
    <aside class="sidebar">
      <ul>
        <li v-for="(item, index) in menuItems" :key="index">
          <div @click="toggleSection(index)" class="item">
            {{ item.title }}
            <span v-if="item.isOpen">▲</span>
            <span v-else>▼</span>
          </div>
          <ul v-show="item.isOpen">
            <li v-for="(subItem, subIndex) in item.sections" :key="subIndex">
              <router-link
                :to="`/document/section/${item.sectionId}/${subItem.subSectionId}`"
                active-class="active-link"
              >
                {{ subItem.name }}
              </router-link>
            </li>
          </ul>
        </li>
      </ul>
    </aside>

    <main class="content">
      <router-view></router-view> <!-- 仅右侧区域更新 -->
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
          sectionId: 1,
          sections: [
            { name: 'Subsection 1.1', subSectionId: 1 },
            { name: 'Subsection 1.2', subSectionId: 2 },
          ],
        },
        {
          title: 'Section 2',
          isOpen: false,
          sectionId: 2,
          sections: [
            { name: 'Subsection 2.1', subSectionId: 1 },
            { name: 'Subsection 2.2', subSectionId: 2 },
          ],
        },
        // 更多 section 可按需添加
      ],
    };
  },
  methods: {
    toggleSection(index) {
      this.menuItems[index].isOpen = !this.menuItems[index].isOpen;
    },
  },
};
</script>
 <style scoped>
   @font-face {
    font-family: 'Montserrat';
    src: url('../assets/fonts/Montserrat/Montserrat-Italic-VariableFont_wght.ttf') format('truetype');
    font-weight: normal;
    font-style: normal;
  }
 /* 黑暗模式+蓝紫调配色 */
 .documentation-page {
   display: flex;
   position: relative;
   top:10vh;
   height: 90vh; /* 整个页面高度 */
   background-color: #1e1e2f; /* 深色背景 */
   color: #c9d1d9; /* 较亮的文字颜色 */
 }
 /* @font-face {
    font-family: 'Montserrat';
    src: url('../assets/fonts/Montserrat/Montserrat-Italic-VariableFont_wght.ttf') format('truetype');
    font-weight: normal;
    font-style: normal;
  }
  *{
    font-family: Montserrat;
    font-weight: bold;
  } */
  .sidebar {
   width: 15vw;
   background-color: #0a0a0a;
   padding: 20px;
   box-shadow: 2px 0 5px rgba(0, 0, 0, 0.3);
   position: fixed; /* 将侧栏固定在屏幕上 */
   top: 10vh; /* 固定在页面顶部 */
   left: 0; /* 固定在页面左侧 */
   height: 100vh; /* 覆盖整个视窗的高度 */
   overflow-y: auto; /* 当内容超出时允许滚动 */
   z-index: 1000; /* 保证侧栏在页面的其他元素之上 */
}
 
 .sidebar .item{
  font-size: 1.2vw;
 }

 .sidebar span{
  font-size: 0.8vw;
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
   color: #168ddb; /* 蓝紫色调 */
   margin-bottom: 5px;
 }
 
 .sidebar ul ul {
   padding-left: 20px;
 }
 
 .sidebar a {
   text-decoration: none;
   color: #168ddb; /* 子菜单的蓝紫色 */
   display: block;
   margin: 5px 0;
 }
 
 .sidebar a:hover {
   color: #ffffff; /* 悬停时更亮 */
 }

 .content {
   margin-left: 15vw; /* 为右侧内容留出侧栏的宽度 */
   background-color: #0c0c0e;
   box-shadow: inset 0 0 10px rgba(0, 0, 0, 0.5);
   overflow-y: auto;
   height: 90vh;
   color: white;
   font-family: Montserrat;
   font-weight: bold;
   top:10vh;
}
 
 /* 层次结构：标题和分割线样式 */
 .content section {
   margin-bottom: 40px;
   z-index: 1000;
 }
 
 h2 {
   border-bottom: 2px solid; /* 分割线 */
   padding-bottom: 10px;
 }
 
 h3 {
   margin-top: 20px;
 }
 
 h4 {
   margin-top: 15px;
 }
 
 p {
   margin-bottom: 15px;
 }
 
 hr {
   border: none;
   margin: 20px 0;
 }
 </style>
 