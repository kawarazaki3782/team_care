<template>
  <div>
    <div v-if="isFavorited" @click="deleteFavorite()">
      お気に入り解除 {{ count }}
    </div>
    <div v-else @click="registerFavorite()">
      お気に入り {{ count }}
    </div>
  </div>
</template>

<script>
// axios と rails-ujsのメソッドインポート
import axios from 'axios'
import { csrfToken } from 'rails-ujs'
// CSRFトークンの取得とリクエストヘッダへの設定をしてくれます
axios.defaults.headers.common['X-CSRF-TOKEN'] = csrfToken()

export default {
  // propsでrailsのviewからデータを受け取る
  props: ['userId', 'micropostId'],
  data() {
    return {
      favoriteList: []  // お気に入り一覧を格納するための変数　{ id: 1, user_id: 1, micropost_id: 1 } がArrayで入る
    }
  },
  
  // 算出プロパティ ここではfavoriteListが変更される度に、count、isFavoritedが再構築される (watchで監視するようにしても良いかも)
  computed: {
//お気に入りの数のを返す
　count() {
      return this.favoriteList.length
    },
    // ログインユーザが既にお気に入り登録しているかを判定する
    isFavorited() {
      if (this.favoriteList.length === 0) { return false }
      return Boolean(this.findFavorited())
    }
  },
  // Vueインスタンスの作成・初期化直後に実行される
  created: function() {
    this.fetchFavoriteByMicropostId().then(result => {
      this.favoriteList = result
    })
  },
  methods: {
     // rails側のcreateアクションにリクエストするメソッド
    registerFavorite: async function() {
      const res = await axios.micropost('/api/favorites', { micropost_id: this.micropostId })
      if (res.status !== 201) {
        // エラー処理
      }
      this.fetchFavoriteByMicropostId().then(result => {
        this.favoriteList = result
      })
    },
    // rails側のdestroyアクションにリクエストするメソッド
    deleteFavorite: async function() {
      const favoriteId = this.findFavoriteId()
      const res = await axios.delete(`/api/favorites/${favoriteId}`)
      if (res.status !== 200) {
        // エラー処理
      }
      this.favoriteList = this.favoriteList.filter(n => n.id !== favoriteId)
    },
    // ログインユーザがお気に入りしているfavoriteモデルのidを返す
    findFavoriteId: function() {
      const favorite = this.favoriteList.find((favorite) => {
        return (favorite.user_id === this.userId)
      })
      if (favorite) { return favorite.id }
    }
  }
}
</script>