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
                    <strong>{{comment.username}}</strong>
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
export default {
    name: 'CommentBox',
    props: {
        comment: Object,
        show: false,
        replys:[],//later maybe
        
    },
    data() {
        return {
            upvoted:false,
        }
    },
    methods:{
        click_upvote(){
            this.upvoted=!this.upvoted;
        },
    }
}
</script>
