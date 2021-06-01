//import Vue from 'vue'
import { createApp } from 'vue'
import App from './App.vue'
import router from './router'
import store from './store'
//Vue.config.productionTip = false
import axios from 'axios'
//console.log(process.env.VUE_APP_SOMEKEY)
//axios.defaults.baseURL = 'https://apidjackets.codewithstein.com'
axios.defaults.baseURL = 'http://127.0.0.1:8000'
//axios.defaults.baseURL = 'https://fast-harbor-30811.herokuapp.com'

// const axiosInstance = axios.create({
//     baseURL: 'http://127.0.0.1:8000',
//     headers: { Authorization: `Bearer ${this.$store.state.token}` },
//   });
  
//export default axiosInstance;
// new Vue({
//   router,
//   store,
//   render: h => h(App)
// }).$mount('#app')
createApp(App).use(store).use(router, axios).mount('#app')

