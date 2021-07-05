<template>
    <div class="new">
        <div class="columns is-multiline is-centered">
            <div class="column is-7">
                
                <!--<InputBox2 :height="400" :boxtype="input_post"/>-->
                <InputBox :height="500" :boxtype="input_post"/>
            </div>
        </div>
    </div>
</template>
<script>
import axios from 'axios'

import InputBox from '@/components/InputBox.vue'

export default {
    name: 'New',
    data() {
    return {
        //latestProducts: [],

    }
    },
    components: {
    //ProductBox,
    InputBox,
    },
    mounted() {
    //this.getLatestProducts()

    document.title = 'Home | Djackets'
    },
    methods: {
    }
}
</script>
<style scoped>
.debug {
    background: lavender;
}
</style>