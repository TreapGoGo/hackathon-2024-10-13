import { createRouter, createWebHistory } from 'vue-router';
import Home from '../views/Home.vue';
import Trade from '../views/Trade.vue';
import Document from '../views/Document.vue';
import ContentWrapper from '../components/ContentWrapper.vue';

const routes = [
    {
        path: '/',
        name: 'home',
        component: Home,
    },
    {
        path: '/trade',
        name: 'trade',
        component: Trade,
    },
    {
        path: '/document',
        name: 'document',
        component: Document,
        children: [
            {
                path: 'section/1/1',
                component: Subsection1_1, // 局部更新到router-view
            },
            {
                path: 'section/1/2',
                component: Subsection1_2, // 局部更新到router-view
            },
            {
                path: 'section/2/1',
                component: Subsection2_1, // 局部更新到router-view
            },
            {
                path: 'section/2/2',
                component: Subsection2_2, // 局部更新到router-view
            },
        ],
    },
];

const router = createRouter({
    history: createWebHistory(),
    routes,
});

export default router;
