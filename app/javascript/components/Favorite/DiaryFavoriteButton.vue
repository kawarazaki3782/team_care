<template>
  <div>
    <button v-if="favoriteId" @click="destroyDiaryFavorite">
      お気に入り解除
    </button>
    <button v-else @click="createDiaryFavorite">
      お気に入り
    </button>
  </div>
</template>

<script>
import axios from 'axios'
export default {
  props: ["userId", "diaryId"],
  data() {
    return {
      favoriteId: null
    }
  },
  created: function() {
    this.fetchApiDiaryFavorite()
  },
  methods: {
    fetchApiDiaryFavorite: async function() {
      const res = await axios.get(`/api/diary/favorite?user_id=${this.userId}&diary_id=${this.diaryId}`)  
      if (res.status !== 200) {
        alert("お気入りの取得に失敗しました")
      } else {
        this.favoriteId = res.data.id
      }
    },
    createDiaryFavorite: async function() {
      const res = await axios.post('/api/diary/favorite', { user_id: this.userId, diary_id: this.diaryId }).catch(err => {
        return err.response
      })
      if (res.status !== 201) {
        alert("お気入りの登録に失敗しました")
      } else {
        this.favoriteId = res.data.id
      }
    },
    destroyDiaryFavorite: async function() {
      const res = await axios.delete('/api/diary/favorite', { data: { id: this.favoriteId }})
      if (res.status !== 200) {
        alert("お気入りの削除に失敗しました")　
      } else {
        this.favoriteId = null
      }
    }
  }
}
</script>

<style scoped>
button {
  display: inline-block;
  line-height: 72px;
  background: #eebeb4;
  color: #fff;
  font-size: 24px;
  font-weight: 700;
  border-radius: 8px;
  outline: none;
  box-shadow: 2px 2px 4px grey;
  margin-bottom: 30px;
  margin-top: 15px;
  cursor: pointer;
}
</style>
