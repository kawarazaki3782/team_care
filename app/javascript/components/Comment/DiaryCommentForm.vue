<template>
  <div>
    <div class="comment_form">
      <input type='textarea' v-model='content'>
      <button @click="createDiaryComment">コメントする</button>
    </div>
    <div v-for="comment in comments" :key="comment.id">
      <hr>
      <ul>
        <li><a v-bind:href="'/users/'+comment.user_id"><img class="user_image" v-bind:src="comment.user_profile_image"></a></li>
        <li><a v-bind:href="'/users/'+comment.user_id">{{ comment.user_name }}</a></li>
        <li>{{ comment.created_at | moment }}</li>
        <li class="comment_content">{{ comment.content }}</li>
      </ul>
      <button v-if="comment.user_id === userId" @click="destroyDiaryComment(comment.id)">削除</button>
    </div>
  </div>
</template>

<script>
import axios from 'axios'
import moment from "moment";
export default {
  filters: {
    moment: function(date) {
      return moment(date).format('YYYY年MM月DD日 HH:mm');
    }
  },
  props: ["userId", "diaryId"],
  data() {
    return {
      content: '',
      comments: []
    }
  },
  created: function() {
    this.fetchApiDiaryComment()
  },
  methods: {
    fetchApiDiaryComment: async function() {
        const res = await axios.get(`/api/diary/comments?diary_id=${this.diaryId}`)
        if (res.status !== 200) {
          alert("コメントの取得に失敗しました")
        } else {
          this.comments = res.data
        }
      },
     createDiaryComment: async function() {
      const res = await axios.post('/api/diary/comments', { user_id: this.userId, diary_id: this.diaryId, content: this.content })
      if (res.status !== 201) {
        alert("コメントの投稿に失敗しました")
      } else {
        this.fetchApiDiaryComment()
        this.content = ""
        alert("コメントを投稿しました")
      }
    },
    destroyDiaryComment: async function(commentId) {
      const res = await axios.delete(`/api/diary/comments/${commentId}`)
      if (res.status != 200) {
        alert("コメントの削除に失敗しました")
      } else {
        this.fetchApiDiaryComment()
        alert("コメントを削除しました")
      }
    }
  }
}
</script>

<style>
.user_image {
  max-width: 100px;
  height: 100px;
  object-fit: cover;
  border-radius: 20%;
  box-shadow: 0 0 0 1px #1a1d21, 0 0 0 2px #e9e9e9;
}

.comment_form {
  text-align: center;
  margin-bottom: 50px;
}

.comment_content {
  overflow-wrap: anywhere;
}
</style>