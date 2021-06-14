<template>
  <div id="wrapper" v-bind:class="{'has-background-black-ter':isDark, 'has-background-white-bis':!isDark}">
    <nav class="navbar" v-bind:class="{'is-dark':isDark, 'is-light':!isDark}">
      <div class="navbar-brand">
        <!--<router-link to="/" class="navbar-item"><strong>Djackets</strong></router-link>
        -->
        <a class="navbar-burger" aria-label="menu" aria-expanded="false" data-target="navbar-menu" @click="showMobileMenu = !showMobileMenu">
          <span aria-hidden="true"></span>
          <span aria-hidden="true"></span>
          <span aria-hidden="true"></span>
        </a>
      </div>

      <div class="navbar-menu" id="navbar-menu" v-bind:class="{'is-active': showMobileMenu }">
        <div class="navbar-start">
          <div class="navbar-item">
            <form method="get" action="/search">
              <div class="field has-addons">
                <div class="control">
                  <input type="text" class="input" placeholder="What are you looking for?" name="query">
                </div>

                <div class="control">
                  <button class="button is-light">
                      <span class="icon">
                      <i class="fas fa-search"></i>
                      </span>
                  </button>
                </div>
              </div>
            </form>
          </div>
        </div>

        <div class="navbar-end">
          
            
          <template v-if="$store.state.isAuthenticated">
            <div class="navbar-item ">
              <router-link to="/new-post" >New</router-link>
            </div>
          
            
          
            <div class="navbar-item has-dropdown is-hoverable">
              <a class="navbar-link is-arrowless">
                PJ
              </a>

              <div class="navbar-dropdown">
                <a class="navbar-item">
                  All
                </a>
                <a class="navbar-item">
                  PJ_1
                </a>
                <a class="navbar-item">
                  PJ_2
                </a>
                <a class="navbar-item">
                  PJ_3
                </a>
              </div>
            </div>
            <div class="navbar-item has-dropdown is-hoverable">
              <a class="navbar-link is-arrowless">
                Topic
              </a>

              <div class="navbar-dropdown">
                <a class="navbar-item">
                  Topic_1
                </a>
                <a class="navbar-item">
                  Topic_2
                </a>
                <a class="navbar-item">
                  Topic_3
                </a>
              </div>
            </div>

          
            <div class="navbar-item has-dropdown is-hoverable">
              <figure class="navbar-link is-arrowless image is-48x48">
                  <img class="is-rounded" src="https://bulma.io/images/placeholders/64x64.png">
              </figure>

              <div class="navbar-dropdown">
                <a class="navbar-item" href="#">
                    <img src="https://bulma.io/images/bulma-logo.png">
                </a>

                
                <router-link class="navbar-item" to="/my-account" >My Page</router-link>
                
                <a class="navbar-item">
                  Notice
                </a>
                <a class="navbar-item" @click="changeTheme()">
                  {{theme}}
                </a>
                <hr class="navbar-divider">
                <a class="navbar-item">
                  <button @click="logout()" class="button is-danger">Log out</button>
                </a>
              </div>
            </div>
          </template>

          <template v-else>
            <div class="navbar-item">
              <router-link to="/" >Home</router-link>
            </div>
            <div class="navbar-item">
              <router-link to="/log-in" >Log in</router-link>
            </div>
          </template>

        </div>
      </div>
    </nav>

    <div class="is-loading-bar has-text-centered" v-bind:class="{'is-loading': $store.state.isLoading }">
      <div class="lds-dual-ring"></div>
    </div>

    <section class="section">
      <router-view/>
    </section>

    <footer class="footer" v-bind:class="{'has-background-black-ter':isDark, 'has-background-white-bis':!isDark}">
      <p class="has-text-right mgb-small is-size-6">Copyright (c) 2021</p>
    </footer>
  </div>
</template>

<script>
import axios from 'axios'

export default {
  data() {
    return {
      showMobileMenu: false,
      cart: {
        items: []
      },
      username:'',
      theme:'dark',
      isDark:false
    }
  },
  beforeCreate() {
    this.$store.commit('initializeStore')
    
    const token = this.$store.state.token

    if (token) {
        axios.defaults.headers.common['Authorization'] = "Token " + token
    } else {
        axios.defaults.headers.common['Authorization'] = ""
    }
  },
  mounted() {
    this.cart = this.$store.state.cart
    this.username=this.$store.state.username
  },
  computed: {
      cartTotalLength() {
          let totalLength = 0

          for (let i = 0; i < this.cart.items.length; i++) {
              totalLength += this.cart.items[i].quantity
          }

          return totalLength
      }
  },
  methods: {
    changeTheme(){
      this.theme=this.isDark?'dark':'light'
      this.isDark=!this.isDark
      
      //$( "#wrapper" ).toggleClass( "className", addOrRemove );
    },
    logout() {
        axios.defaults.headers.common["Authorization"] = ""

        localStorage.removeItem("token")
        localStorage.removeItem("username")
        localStorage.removeItem("userid")

        this.$store.commit('removeToken')

        this.$router.push('/')
    },
    mouseOverAction(){
        this.hoverFlag = true
    },
    mouseLeaveAction(){
        this.hoverFlag = false
    }
  }
}
</script>

<style lang="scss">
@import '../node_modules/bulma';

.lds-dual-ring {
  display: inline-block;
  width: 80px;
  height: 80px;
}
.lds-dual-ring:after {
  content: " ";
  display: block;
  width: 64px;
  height: 64px;
  margin: 8px;
  border-radius: 50%;
  border: 6px solid #ccc;
  border-color: #ccc transparent #ccc transparent;
  animation: lds-dual-ring 1.2s linear infinite;
}
@keyframes lds-dual-ring {
  0% {
    transform: rotate(0deg);
  }
  100% {
    transform: rotate(360deg);
  }
}

.is-loading-bar {
  height: 0;
  overflow: hidden;

  -webkit-transition: all 0.3s;
  transition: all 0.3s;

  &.is-loading {
    height: 80px;
  }
}
@media screen and (min-width: 1088px) {
  .navbar-start {
    margin-left: auto;
    margin-right: 150px;
  }
  .navbar-end {
    margin-right: auto;
    margin-left: 150px;
  }
}
@import "./assets/css/_color.scss";
</style>
