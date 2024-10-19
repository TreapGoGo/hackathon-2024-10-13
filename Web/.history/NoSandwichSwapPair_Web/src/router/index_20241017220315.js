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
        component: Document, // 文档主页面
        children: [
            {
                path: 'section/:sectionId/:subSectionId',
                component: ContentWrapper, // 子路由加载不同 section
                props: true, // 传递参数作为 props
            },
        ],
    },
];

const router = createRouter({
    history: createWebHistory(),
    routes,
});

export default router;
