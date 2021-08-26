// import 'babel-polyfill'
import Vue from 'vue'

// 作成したコンポーネントファイルをimportします
import DiaryFavoriteButton from '../components/Favorite/DiaryFavoriteButton.vue'

document.addEventListener('DOMContentLoaded', () => {
  new Vue({
    el: '#diary_favorite_button',
    components: { DiaryFavoriteButton }
  })
})