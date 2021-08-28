class Api::Diary::CommentsController < ActionController::API
    def index 
      if Diary.exists?(params[:diary_id])
        comments = Diary.find(params[:diary_id]).comments.map do |comment|
          {
            content: comment.content,
            created_at: comment.created_at,
            user_name: comment.user.name,
            user_profile_image: comment.user.profile_image.url,
            id: comment.id,
            user_id: comment.user_id
          }
        end
        render status: 200, json: comments
      else
        head :not_found
      end
    end
    
    def create
      if Diary.exists?(params[:diary_id])
        comment = Comment.create!(comment_params)
        diary = comment.diary
        diary.create_notification_comment!(comment.user, comment.id, diary)
        render status: 201, json: { id: comment.id }
      else
        head :not_found
      end
    end
  
    def destroy
      Comment.find(params[:id]).destroy!
      head :ok
    end
    
    private
  
    def comment_params
      params.require(:comment).permit(:diary_id, :user_id, :content)
    end
  end