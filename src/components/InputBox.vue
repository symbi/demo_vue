<template>

    <form v-on:submit.prevent>
        <div class="row">
            <div class="mb-3">
                <ckeditor :editor="editor" @ready="onReady" v-model="editorData" :config="editorConfig"></ckeditor>
                
            </div>
            <button class="button is-dark" @click="submitForm">test</button>
        </div>
    </form>
    
</template>

<script>
import CKEditor from '@ckeditor/ckeditor5-vue';
import DocumentEditor from '@ckeditor/ckeditor5-build-decoupled-document';
import axios from 'axios'
import jQuery from 'jquery';
//import DecoupledEditor from '@ckeditor/ckeditor5-build-decoupled-document';

export default {
    name: 'InputBox',
    props: {
        username: String,
        height:String,
        //post: Object,
        //comments:Array,

    },
    components: {
        ckeditor: CKEditor.component
    },
    data() {
        return {
            editor: DocumentEditor,
            editorData: '',
            editorConfig: {
                placeholder: this.checkNull('username',this.username),
                ckfinder: {
                    uploadUrl: 'http://localhost:8000/api/v1/test/'
                },
                toolbar: {
                    items: [
                    'heading',
                    '|',
                    'fontSize',
                    'fontFamily',
                    'fontColor',
                    'fontBackgroundColor',
                    //'imageInsert',
                    '|',
                    'bold',
                    'italic',
                    'underline',
                    'strikethrough',
                    //'highlight',
                    //'removeFormat',
                    '|',
                    'alignment',
                    '|',
                    'numberedList',
                    'bulletedList',
                    '|',
                    'indent',
                    'outdent',
                    '|',
                    //'todoList',
                    'link',
                    'blockQuote',
                    'imageUpload',
                    'insertTable',
                    'mediaEmbed',
                    '|',
                    'undo',
                    'redo',
                    'CKFinder'
                    ],
                    //viewportTopOffset: 30,
                    shouldNotGroupWhenFull: true
                },
                language: 'cs',
                image: {
                    toolbar: [
                    'imageTextAlternative',
                    'imageStyle:full',
                    //'imageStyle:side',
                    //'linkImage'
                    ]
                },
                table: {
                    contentToolbar: [
                    'tableColumn',
                    'tableRow',
                    'mergeTableCells'
                    ]
                },
                licenseKey: ''
            },
            errors:[],


        }
    },
    computed: {
        // commentsLength() {
        //     return this.cart.items.reduce((acc, curVal) => {
        //         return acc += curVal.quantity
        //     }, 0)
        // },
    },
    methods:{
        checkNull(flag,value){
            console.log("CheckNull:",flag,value);
            switch(flag){
                case 'height':
                    if(value==null || value==undefined){
                        return '100px';
                    }else{
                        console.log(this.height+'px');
                        return this.height+'px';
                    }
                    

                case 'username':
                    if(value==null || value==undefined)return '.....';
                    return '@'+this.username;
                default:
                    return '';
                
            }
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
        onReady( editor )  {
            // Insert the toolbar before the editable area.
            editor.ui.getEditableElement().parentElement.insertBefore(
                    editor.ui.view.toolbar.element,
                    editor.ui.getEditableElement()
            );
            //editor.ui.view.editable.element.style.height = this.checkNull('height',this.height);

        },
        submitForm() {
            this.$store.commit('setIsLoading', true)
            
            const csrftoken = this.getCookie('csrftoken');
            console.log("csrftoken:",csrftoken);

            this.stripeTokenHandler();
            
        },
        async stripeTokenHandler() {
            console.log("editorData:",this.editorData);

            const data = {
                //'first_name': 'test',
                'body':this.editorData,
            }
            let hd = {
                'Content-Type':'application/json',
                'Authorization':'Bearer'+this.$store.state.token
            }


                // axios.post("http://api.rumaholi.local/api/post", [], {headers: { 'Authorization' : 'Bearer '+ token}}).then(response => {
                //         this.comments = response.data;
                //         console.log(response.data)
                //     })
            //`Bearer ${this.$store.state.token}`, {headers:hd} 
            await axios
                .post('/api/v1/new/', data)
                .then(response => {
                    console.log("post res:",response);
                    //this.$store.commit('clearCart')
                    this.$router.push('/')
                })
                .catch(error => {
                    this.errors.push('Something went wrong. Please try again')

                    console.log(error)
                })

                this.$store.commit('setIsLoading', false)
        }
    },
}
</script>

<style >
.ck-toolbar.ck-toolbar_floating>.ck-toolbar__items { flex-wrap: wrap; } 

.ck-editor__editable {
    min-height: 300px !important;
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