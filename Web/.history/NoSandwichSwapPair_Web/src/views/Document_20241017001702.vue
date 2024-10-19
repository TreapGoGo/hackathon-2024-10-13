<style scoped>
/* 黑暗模式+蓝紫调配色 */
.documentation-page {
  display: flex;
  min-height: 100vh;
  background-color: #1e1e2f; /* 深色背景 */
  color: #c9d1d9; /* 较亮的文字颜色 */
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
