<template>

    <form v-on:submit.prevent>
        <div class="row">
            <div class="mb-3">
                <ckeditor :editor="editor" :style="styleObject" @ready="onReady" v-model="editorData" :config="editorConfig"></ckeditor>
                
            </div>
            <button class="button is-dark" @click="submitForm">test</button>
        </div>
    </form>
    
</template>

<script>
//import CKEditor from '@ckeditor/ckeditor5-vue';
//import ImageInsert from '@ckeditor/ckeditor5-image/src/imageinsert';
//import ClassicEditor from '@ckeditor/ckeditor5-editor-classic/src/classiceditor';
//import DocumentEditor from '@ckeditor/ckeditor5-build-decoupled-document';
//import ClassicEditor from '@ckeditor/ckeditor5-build-classic';
import axios from 'axios'
import jQuery from 'jquery';
//import DecoupledEditor from '@ckeditor/ckeditor5-build-decoupled-document';

export default {
    name: 'InputBox',
    props: {
        username: String,
        height:String,
        boxtype:String,
        key:String,
        poster_id:String,
        //post: Object,
        //comments:Array,

    },
    components: {
        ckeditor: CKEditor.component
    },
    data() {
        return {
            editor: DocumentEditor,
            //editor: ClassicEditor,
            editorData: '',
            editorConfig: {
                placeholder: this.checkNull('username',this.username),
                ckfinder: {
                    uploadUrl: axios.defaults.baseURL+'/api/v1/uploads/images/',
                    options:{
                        resourceType: "Images",
                    },
                    headers: {
                        'X-CSRF-TOKEN': this.getCookie('csrftoken'),
                    }
                },
                //plugins: [ImageInsert],
                toolbar: {
                    items: this.getItems(),
                    //viewportTopOffset: 30,
                    shouldNotGroupWhenFull: true
                },
                language: 'cs',
                image: {
                    toolbar: [
                    'imageTextAlternative',
                    'imageStyle:full',
                    'imageStyle:side',
                    'linkImage'
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
        styleObject() {
        return {
            '--box-height': this.height+'px',
        };
        },
    },
    methods:{
        getItems(){
            let ret=[
                    'heading',
                    '|',
                    'fontSize',
                    'fontFamily',
                    'fontColor',
                    'fontBackgroundColor',
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
                    'imageInsert',
                    'insertTable',
                    'mediaEmbed',
                    '|',
                    'undo',
                    'redo',
                    'CKFinder'
                    ]
            if(this.boxtype=='input_comment'){
                ret=[
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
                    'imageInsert',
                    'insertTable',
                    'mediaEmbed',
                    '|',
                    'undo',
                    'redo',
                    'CKFinder'
                    ]
            }
            return ret
        },
        checkNull(flag,value){
            switch(flag){
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
                'poster_id':this.poster_id,
            }
            const url_post=this.boxtype=='input_comment'?'/api/v1/new_comment/':'/api/v1/new/';

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
        }
    },

}
</script>

<style >
.ck-toolbar.ck-toolbar_floating>.ck-toolbar__items { flex-wrap: wrap; } 

.ck-editor__editable {
    min-height: var(--box-height) !important;
    
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