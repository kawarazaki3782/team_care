<template>
  <div>
    <input type='textarea' v-model='content'>
    <button @click="createMicropostComment">コメントする</button>
  </div>
</template>

<script>
import axios from 'axios'
export default {
  props: ["userId", "micropostId"],
  data() {
    return {
      commentId: null,
      content: ''
    }
  },
  created: function() {
    this.fetchApiMicropostComment()
  },
  methods: {
    fetchApiMicropostComment: async function() {
        const res = await axios.get(`/api/micropost/comment?user_id=${this.userId}&micropost_id=${this.micropostId}`)
        if (res.status !== 200) {
          alert("コメントの取得に失敗しました")
        } else {
          this.commentId = res.data.id
        }
      },
     createMicropostComment: async function() {
      const res = await axios.post('/api/micropost/comment', { user_id: this.userId, micropost_id: this.micropostId, content: this.content })
      if (res.status !== 201) {
        alert("コメントの投稿に失敗しました")
      } else {
        this.commentId = res.data.id
      }
    }
  }
}
</script>

<style>
</style>