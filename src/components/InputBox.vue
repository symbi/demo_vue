<template>

    <!-- <button class="test" :style="btnStyles">My button</button> -->
    <form v-on:submit.prevent="submitForm">
        <div class="row">
            <div class="mb-3">
                <ckeditor :editor="editor" v-model="editorData" :style="btnStyles" 
                :config="editorConfig" @destroy="onEditorDestroy" @uploadComplete='onComplete'></ckeditor>
            </div>
            <button class="button is-dark">send</button>
        </div>
    </form>
    
</template>

<script>
    import axios from 'axios'
    import jQuery from 'jquery';
    import CKEditor from '@ckeditor/ckeditor5-vue';
    import ClassicEditor from '../assets/js/ckeditor';

    export default {
        name: 'InputBox2',
        components: {
            ckeditor: CKEditor.component
        },
        props: {
            username: String,
            //height:String,
            boxtype:String,
            key:String,
            poster_id:String,
            bgColor: {
                type: String,
                default: "#db277b"
            },
            height: {
                type: Number,
                default: 300
            }
        },
        data() {
            return {
                var:'60px',
                color: 'red',
                editor: ClassicEditor,
                editorData: '',
                editorConfig: {
                    placeholder: this.getPlaceholder(),
                    ckfinder: {
                        uploadUrl: axios.defaults.baseURL+'/api/v1/uploads/images/',
                        options:{
                            resourceType: "Images",
                        },
                        headers: {
                            'X-CSRF-TOKEN': this.getCookie('csrftoken'),
                        }
                    },
                    toolbar: {
                        items: this.getItems(),
                        //viewportTopOffset: 30,
                        shouldNotGroupWhenFull: true
                    },
                    language: 'cs',
                    image: {
                        toolbar: [
                        'imageStyle:full',
                        'imageStyle:side',
                        '|',
                        'imageTextAlternative',
                        //'linkImage'
                        ]
                    },

                    fontSize: {
                        options: [
                            9,
                            11,
                            13,
                            'default',
                            17,
                            19,
                            21
                        ]
                    },
                    fontFamily: {
                      supportAllValues: true
                    },
                    table: {
                        contentToolbar: [
                        'tableColumn',
                        'tableRow',
                        'mergeTableCells'
                        ]
                    },
                    licenseKey: '',
                },
            };
        },
        computed: {
            onHello(){
                console.log("hello");
            },
            styleObject() {
              //console.log("styly obj:",this.height)
              return {'--height': this.height + 'px'};
            },
            btnStyles() {
              return {
                // "background-color": this.bgColor,
                // height: `${this.height}px`
                '--bg-color': this.bgColor,
                '--height': this.height + 'px',
                '--test':`${this.height}px`,
              };
            },
        },
        methods:{
            onComplete(data){
                console.log("----onComplete-----data:",data);
            },
            imageRemove(images) {
                console.log("----imageRemove-----images:",images);
                this.$store.commit('setIsLoading', true)
                this.testDel(images);
                //https://github.com/shiva2021/resuable-ckeditor-component/blob/main/ckeditor.vue
                /** HANDLE THE IMAGE DELETION IN YOUR PARENT COMPONENT */
                //this.$emit("imageRemove", images);
            },
            onEditorDestroy(){
                console.log("----onEditorDestroy-----");
            },
            getItems(){
                let ret=[
                  // 'heading',
                  // '|',
                  'fontFamily',
                  'fontSize',
                  'fontColor',
                  'fontBackgroundColor',                  
                  '|',
                  'bold',
                  'italic',
                  'link',
                  'bulletedList',
                  //'numberedList',
                  '|',
                  'outdent',
                  'indent',
                  '|',
                  //'uploadImage',
                  'insertImage',
                  'blockQuote',
                  'insertTable',
                  'mediaEmbed',
                  'undo',
                  'redo'
                ]
                return ret
            },
            getPlaceholder(){
                if(this.username==null || this.username==undefined)
                  return '......'
                return '@'+this.username
            },
            getCookie(name) {
                var cookieValue = null;
                if (document.cookie && document.cookie !== '') {
                    var cookies = document.cookie.split(';');
                    for (var i = 0; i < cookies.length; i++) {
                        var cookie = jQuery.trim(cookies[i]);
                        if (cookie.substring(0, name.length + 1) === (name + '=')) {
                            cookieValue = decodeURIComponent(cookie.substring(name.length + 1));
                            break;
                        }
                    }
                }
                return cookieValue;
            },
            submitForm() {
                console.log("submitForm---");
                this.$store.commit('setIsLoading', true)
                
                const csrftoken = this.getCookie('csrftoken');
                console.log("csrftoken:",csrftoken);

                this.stripeTokenHandler();
                
            },
            async stripeTokenHandler() {
                console.log("editorData bf:",this.editorData);

                //The <oembed></oembed> tags to <ifame></iframe> tags
                //url part of the video to src
                this.editorData=this.editorData.replace(/<oembed/g, "<iframe").replace(/<\/oembed>/g,'</iframe>').
                replace(/url=/g,'src=').replace(/watch\?v=/g,'embed/'); 
                this.editorData=this.editorData.replace('<figure class="media">','<figure class="media" v-bind:width="width" v-bind:height="height">');
                this.editorData=this.editorData.replace('<figure class="image">','<figure class="image" v-bind:width="width" v-bind:height="height">');
                console.log("editorData af:",this.editorData);
                const url_post=this.boxtype=='input_comment'?'/api/v1/new_comment/':'/api/v1/new/';

                const data = {
                    //'first_name': 'test',
                    'body':this.editorData,
                    'poster_id':this.poster_id,
                }
                await axios
                    .post(url_post, data)
                    .then(response => {
                        console.log("post res:",response,this.poster_id in window);
                        //this.$store.commit('clearCart')
                        
                        if(this.poster_id in window){
                            this.$router.push('/')
                        }else{
                            console.log("going to emit data:",response.data);
                            this.$emit('posted', response.data)
                        }
                            
                    })
                    .catch(error => {
                        this.errors.push('Something went wrong. Please try again')

                        console.log(error)
                    })

                    this.$store.commit('setIsLoading', false)
            },
            async testDel(images) {
                console.log("testDel----",this.editorData);

                const data = {
                    //'first_name': 'test',
                    'images':images,
                    'body':this.editorData,
                    'poster_id':this.poster_id,
                }
                
                const filename=images[0].split("images/")[1];
                console.log("filename:",images[0].split("images/"))
                
                const url_post='/api/v1/uploads/images/'+filename;
                await axios
                    .delete(url_post)
                    .then(response => {
                        console.log("post res:",response,this.poster_id in window);
                        //this.$store.commit('clearCart')
                        
                        // if(this.poster_id in window){
                        //     this.$router.push('/')
                        // }else{
                        //     console.log("going to emit data:",response.data);
                        //     this.$emit('posted', response.data)
                        // }
                            
                    })
                    .catch(error => {
                        this.errors.push('Something went wrong. Please try again')

                        console.log(error)
                    })

                    this.$store.commit('setIsLoading', false)
            }
        },
        async created() {
            //this.editorConfig.simpleUpload.headers.Authorization = `Bearer ${localStorage.getItem("barter-token")}`;
            //this.editorConfig.simpleUpload.uploadUrl = `http://127.0.0.1:3333/api/barter/s3/editorimage/upload/`;
            this.editorConfig.imageRemoveEvent = { callback: this.imageRemove };
        },
        mounted(){      
        }
    };
</script>



<style >
.ck-toolbar.ck-toolbar_floating>.ck-toolbar__items { flex-wrap: wrap; } 

.ck-editor__editable{
    /*--box-height: 800px;
     min-height: var(--height); */
    min-height: 500px;
}
button{
    background-color: var(--bg-color);
    /* height: var(--height); */
    height: var(--test);
}
/* .ck-content .image.image_resized {
    display: block;
    box-sizing: border-box;
}

.ck-content .image.image_resized img {
    width: 100%;
}

.ck-content .image.image_resized > figcaption {
    display: block;
} */
/* div.cl p {
 height: var(--p-height);
 border: 1px solid black;
 margin: 2px;
}
.test {
  --var-txt-color: #c1d32f;
  color: var(--var-txt-color);
} 

.test-child-node {
  background-color: var(--var-txt-color);
}*/
</style>