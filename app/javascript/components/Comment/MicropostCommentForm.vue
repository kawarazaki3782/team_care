<template>
  <div>
    <input type='textarea' v-model='content'>
    <button @click="createMicropostComment">コメントする</button>
    <div v-for="comment in comments" :key="comment.id">
      <ul>
        <li>{{ comment.user_name }}</li>
        <li>{{ comment.created_at }}</li>
        <li>{{ comment.content }}</li>
        <li>{{ comment.user_profile_image }}</li>
      </ul>
      <hr>
      <button @click="destroyMicropostComment">削除</button>
    </div>
  </div>
</template>

<script>
import axios from 'axios'
export default {
  props: ["userId", "micropostId"],
  data() {
    return {
      commentId: null,
      content: '',
      comments: []
    }
  },
  created: function() {
    this.fetchApiMicropostComment()
  },
  methods: {
    fetchApiMicropostComment: async function() {
        const res = await axios.get(`/api/micropost/comments?micropost_id=${this.micropostId}`)
        if (res.status !== 200) {
          alert("コメントの取得に失敗しました")
        } else {
          this.comments = res.data
        }
      },
     createMicropostComment: async function() {
      const res = await axios.post('/api/micropost/comments', { user_id: this.userId, micropost_id: this.micropostId, content: this.content })
      if (res.status !== 201) {
        alert("コメントの投稿に失敗しました")
      } else {
        this.commentId = res.data.id
      }
    },
    destroyMicropostComment: async function() {
      const res = await axios.delete('/api/micropost/comments', { data: { id: this.commentId }})
      if (res.status != 200) {
        alert("コメントの削除に失敗しました")
      } else {
        this.commentId = null
      }
    }
  }
}
</script>

<style>
</style>