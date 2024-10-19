<template>
  <div>
    <component :is="currentComponent"></component>
  </div>
</template>

<script>
export default {
  props: ['sectionId', 'subSectionId'],
  computed: {
    currentComponent() {
      const sectionId = this.sectionId;
      const subSectionId = this.subSectionId;
      const componentMap = {
        '1': {
          '1': () => import('./documents/Subsection1_1.vue'),
          '2': () => import('./documents/Subsection1_2.vue'),
        },
        '2': {
          '1': () => import('./documents/Subsection2_1.vue'),
          '2': () => import('./documents/ Subsection2_2.vue'),
        },
        // 更多的 section 映射可按需添加
      };
      return componentMap[sectionId]?.[subSectionId] || null;
    },
  },
};
</script>
