// import 'babel-polyfill'
import Vue from 'vue'

// 作成したコンポーネントファイルをimportします
import DiaryCommentForm from '../components/Comment/DiaryCommentForm.vue'

document.addEventListener('DOMContentLoaded', () => {
  new Vue({
    el: '#diary_comment_form',
    components: { DiaryCommentForm }
  })
})


