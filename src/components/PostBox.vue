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
                <strong>{{post.user}}</strong>
                <br>
                <span v-html="post.body"></span>
                <br>
                </p>
                <nav class="level is-mobile">

                    <div class="level-left">
                        <a class="level-item" v-bind:class="{'icon_toclick':!upvoted, 'icon_clicked_vote':upvoted}" 
                        aria-label="upvote" @click="click_upvote">
                            <span class="icon is-small">
                            <i class="fas fa-thumbs-up" aria-hidden="true"></i>
                            </span><small>{{post.points}}</small>
                        </a>
                        
                        <a class="level-item" @click="click_comments" aria-label="comments">
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
                            <small>{{post.x_ago}}</small>
                        </div>                            

                    </div>
                </nav>
            </div>
            <div v-if="!toReply">
                <CommentBox v-if="!is_clicked_comments && comments.length>0"
                v-bind:key="comments[0].id"
                v-bind:comment="comments[0]"/>
                
                <CommentBox v-else
                v-for="comment in comments"
                v-bind:key="comment.id"
                v-bind:comment="comment"/>
            </div>
            <div v-else>
                <InputBox @posted="onPostedChild"
                :key="post.id"
                :poster_id="post.id"
                :username="post.user"
                :height="100"
                :boxtype="'input_comment'"/>
            </div>
        </div>
    </article>
    </div>
</template>

<script>
import CommentBox from '@/components/CommentBox.vue'
import InputBox from '@/components/InputBox.vue'
import "bulma";
export default {
    name: 'PostBox',
    props: {
        post: Object,
        comments:{
            type:Array,
            default:[]
        },

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
            isHovering:false,
            bgcolor: "#db277b"
        }
    },
    methods:{
        onPostedChild (value) {
            //this.comments.push(value)
            this.comments.unshift(value);
            this.is_clicked_comments=true
            this.toReply=false
        },
        is_mouseover(){
            console.log("mouseover");
            this.bgcolor="#0887ee"
        },
        is_mouseleave(){
             console.log("mouseleave");
            this.bgcolor="#012c4e"
        },
        click_comments(){
            
            if(this.toReply){
                this.toReply=false;
                this.is_clicked_comments=true;
            }else{
                this.is_clicked_comments=!this.is_clicked_comments;
            }
            
        },
        click_upvote(){
            console.log("postbox click_upvote before:",this.upvoted);
            this.upvoted=!this.upvoted;
        },
        click_reply(){
            if(this.is_clicked_comments)
                this.is_clicked_comments=false;
            this.toReply=!this.toReply;
        }
        
    },
    computed: {
        styleObject() {
        return {
            '--box-bg-color': this.bgcolor,
        };
        },
    },
}
</script>
<style>
:root {
    --blue: #0887ee;
    --pink: #db277b;
}
</style>

<style scoped>
/* src="../assets/css/_color.css" */
.icon_toclick {
    color: var(--blue);
}

.icon_clicked_vote {
    color: var(--pink);
}
::v-deep(.icon_clicked_vote) {
    color: var(--pink);
}
::v-deep(.icon_toclick) {
    color:  var(--blue);
}



/* .hoverbox{
    box-shadow: 0px 2px 4px 0px rgba(0, 0, 0, 5);
}

custombox{
    background-color:#4b0f5e;
}
custombox:hover {
    background-color:#0f5e5a;
    box-shadow: 0 0.5em 1em -0.125em rgba(#4b0f5e, 0.1), 0 0px 0 1px rgba(#4b0f5e, 2);
} */
</style>
<style lang="scss">

    // $link:#0887ee;
    // $link-invert: #012c4e;
    // $link-focus-border: #4b0f5e;
  /*$blue: #0887ee;
  
  $scheme-invert:#4b0f5e;
  $box-background-color:var(--box-bg-color);
  $box-link-hover-shadow: 0 0.5em 1em -0.125em rgba(0, 255, 0, 0.1), 0 0 0 1px $blue;
  $box-shadow: 0 0.5em 1em -0.125em rgba($scheme-invert, 1), 0 0px 0 1px rgba($scheme-invert, 0.02);
  */
  //@import '~bulma';
</style>