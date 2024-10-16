import { createRouter, createWebHistory } from 'vue-router'
import Home from '../views/Home.vue'
import Trade from '../views/Trade.vue'
const routes = [
    {
        path: '/',
        name: 'home',
        component: Home
    },
    {
        path: '/trade',
        name: 'trade',
        component: Trade
    }
]

const router = createRouter({
    history: createWebHistory(),
    routes
})

export default router