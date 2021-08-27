// import 'babel-polyfill'
import Vue from 'vue'

// 作成したコンポーネントファイルをimportします
import MicropostCommentButton from '../components/Comment/MicropostCommentButton.vue'

document.addEventListener('DOMContentLoaded', () => {
  new Vue({
    el: '#micropost_comment_button',
    components: { MicropostCommentButton }
  })
})