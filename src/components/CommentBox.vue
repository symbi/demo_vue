<template>
    <div class="column is-12">
        <article class="media">
            <figure class="media-left">
            <p class="image is-48x48">
                <img src="https://bulma.io/images/placeholders/96x96.png">
            </p>
            </figure>
            <div class="media-content">
                <div class="content">
                    <p>
                    <strong>{{comment.user}}</strong>
                    <br>
                    <span v-html="comment.body"></span>
                    <br>
                    </p>
                </div>
                <nav class="level is-mobile">

                    <div class="level-left">
                        <a class="level-item" aria-label="like" 
                        v-bind:class="{'icon_toclick':!upvoted, 'icon_clicked_vote':upvoted}" @click="click_upvote">
                            <span class="icon is-small">
                            <i class="fas fa-thumbs-up" aria-hidden="true"></i>
                            </span><small>{{comment.points}}</small>
                        </a>
                        
                        <!--<a class="level-item" aria-label="comments">
                            <span class="icon is-small">
                            <i class="fas fa-comment" aria-hidden="true"></i>
                            </span><small>{{replys.length}}</small>
                        </a>-->

                        <a class="level-item" aria-label="comments">
                            <small>{{comment.x_ago}}</small>
                        </a>                            

                    </div>
                </nav>
                <!--
                <ReplyBox
                v-for="reply in replys"
                v-bind:key="reply.id"
                v-bind:reply="reply"/>-->
            </div>
        </article>
    </div>
</template>
<script>
//import CommentBox from '@/components/CommentBox.vue'
import axios from 'axios'
export default {
    name: 'CommentBox',
    props: {
        comment: Object,
        show: false,
        replys:[],//later maybe
        
    },
    data() {
        return {
            upvoted:this.comment.upvoted,
        }
    },
    created(){
        //this.upvoted=this.comment.upvoted
        
    },
    methods:{
        async click_upvote(){
            console.log("postbox click_upvote---");
            
            this.$store.commit('setIsLoading', true)
            const data={}
            data.action=this.upvoted?'cancle':'upvote'
            data.vote_type='comment'
            await axios
                .post('/api/v1/vote/'+this.comment.id+'/',data)
                .then(response => {
                    this.upvoted=!this.upvoted;
                    console.log("response:",response.data)
                    this.comment.points=response.data.points
                })
                .catch(error => {
                    if (error.response) {
                        for (const property in error.response.data) {
                            this.errors.push(`${property}: ${error.response.data[property]}`)
                        }

                        console.log(JSON.stringify(error.response.data))
                    } else if (error.message) {
                        this.errors.push('Something went wrong. Please try again')
                        console.log(JSON.stringify(error))
                    }
                })

            this.$store.commit('setIsLoading', false)           
        },
    }
}
</script>
