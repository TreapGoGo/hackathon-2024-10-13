import { createRouter, createWebHistory } from 'vue-router'
import Home from '../views/Home.vue'
import Trade from '../views/Trade.vue'
import Explore from '../views/Explore.vue'
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
    },
    {
        path: '/explore',
        name: 'explore',
        component: Explore
    },
]

const router = createRouter({
    history: createWebHistory(),
    routes
})

export default router