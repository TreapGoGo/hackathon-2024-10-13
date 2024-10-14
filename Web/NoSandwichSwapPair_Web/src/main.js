import { createApp } from 'vue'
import './style.css'
import App from './App.vue'
import router from './router'
import store from './store' // 引入 Vuex store

// 创建应用实例并注入 Vue Router 和 Vuex store
createApp(App)
    .use(router)  // 使用 Vue Router
    .use(store)   // 使用 Vuex store
    .mount('#app')
