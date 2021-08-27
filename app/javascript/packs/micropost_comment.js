// import 'babel-polyfill'
import Vue from 'vue'

// 作成したコンポーネントファイルをimportします
import MicropostCommentForm from '../components/Comment/MicropostCommentForm.vue'

document.addEventListener('DOMContentLoaded', () => {
  new Vue({
    el: '#micropost_comment_form',
    components: { MicropostCommentForm }
  })
})


