<template>
    
    <div class="box">
    <article class="media">
        <figure class="media-left">
        <p class="image is-64x64">
            <img src="https://bulma.io/images/placeholders/128x128.png">
        </p>
        </figure>
        <div class="media-content">
            <div class="content">
                <p>
                <strong>{{post.username}}</strong>
                <br>{{post.content}}<br>
                </p>
                <nav class="level is-mobile">

                    <div class="level-left">
                        <a class="level-item" v-bind:class="{'icon_toclick':!upvoted, 'icon_clicked_vote':upvoted}" 
                        aria-label="upvote" @click="click_upvote">
                            <span class="icon is-small">
                            <i class="fas fa-thumbs-up" aria-hidden="true"></i>
                            </span><small>{{post.points}}</small>
                        </a>
                        
                        <a class="level-item" v-bind:class="{'icon_toclick':!is_clicked_comments, 'icon_clicked':is_clicked_comments}" aria-label="comments" @click="click_comments">
                            <span class="icon is-small">
                            <i v-if="!is_clicked_comments" class="fas fa-comment" aria-hidden="true"></i>
                            <!--<i class="fas fa-chevron-down" aria-hidden="true"></i>-->
                            <i v-else class="fas fa-chevron-up" aria-hidden="true"></i>
                            </span><small>{{comments.length}}</small>
                        </a>

                       
                        <a class="level-item" v-bind:class="{'icon_toclick':!toReply, 'icon_clicked':toReply}" aria-label="reply" @click="click_reply">
                            <span class="icon is-small">
                            <i class="fas fa-reply" aria-hidden="true"></i>
                            </span>
                        </a>

                        <div class="level-item" aria-label="comments">
                            <small>2 hrs</small>
                        </div>                            

                    </div>
                </nav>
            </div>
            <div v-if="!toReply">
                <CommentBox v-if="!is_clicked_comments"
                v-bind:key="comments[0].id"
                v-bind:comment="comments[0]"/>
                
                <CommentBox v-else
                v-for="comment in comments"
                v-bind:key="comment.id"
                v-bind:comment="comment"/>
            </div>
            <div v-else>
                <InputBox 
                v-bind:key="post.id"
                v-bind:username="post.username"/>
            </div>
        </div>
    </article>
    </div>
</template>

<script>
import CommentBox from '@/components/CommentBox.vue'
import InputBox from '@/components/InputBox.vue'

export default {
    name: 'PostBox',
    props: {
        post: Object,
        comments:Array,

    },
    components: {
        CommentBox,
        InputBox,
    },
    data() {
        return {
            is_clicked_comments:false,
            upvoted:false,
            toReply:false,
        }
    },
    methods:{

        click_comments(){
            
            if(this.toReply){
                this.toReply=false;
                this.is_clicked_comments=true;
            }else{
                this.is_clicked_comments=!this.is_clicked_comments;
            }
            
        },
        click_upvote(){
            this.upvoted=!this.upvoted;
        },
        click_reply(){
            if(this.is_clicked_comments)
                this.is_clicked_comments=false;
            this.toReply=!this.toReply;
        }
        
    },
}
</script>

<style scoped>
.icon_toclick {
    color: #0887ee;
}
.icon_clicked {
    color: #012c4e;
}

.icon_clicked_vote {
    color: #db277b;
}
/*
.ck-editor .ck-editor__main .ck-content {
    min-height: 500px;
}
.ck-editor__top {
    width: 500px;
}
*/
.ck-toolbar.ck-toolbar_floating>.ck-toolbar__items { flex-wrap: wrap; } 

.ck-editor__editable {
    min-height: 100px !important;
}
/*
@media screen and (min-width: 1000px){
.is-width-960px {
    max-width: 960px!important;
}
}
 .image {
    margin-top: -1.25rem;
    margin-left: -1.25rem;
    margin-right: -1.25rem;
  } */
</style>