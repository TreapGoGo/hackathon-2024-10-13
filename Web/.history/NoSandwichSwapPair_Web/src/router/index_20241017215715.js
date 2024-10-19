import { createRouter, createWebHistory } from 'vue-router'
import Home from '../views/Home.vue'
import Trade from '../views/Trade.vue'
import Document from '../views/Document.vue'
import Subsection1_1 from '../components/documents/Subsection1_1.vue'
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
        path: '/document',
        name: 'document',
        component: Document
    },
    {
        path: ''
    }
]

const router = createRouter({
    history: createWebHistory(),
    routes
})

export default router