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
            '1': () => import('@/components/Subsection1_1.vue'),
            '2': () => import('@/components/Subsection1_2.vue'),
          },
          '2': {
            '1': () => import('@/components/Subsection2_1.vue'),
            '2': () => import('@/components/Subsection2_2.vue'),
          },
          // Add more mappings as needed
        };
        return componentMap[sectionId]?.[subSectionId] || null;
      },
    },
  };
  </script>
  