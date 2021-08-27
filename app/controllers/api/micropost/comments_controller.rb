class Api::Micropost::CommentsController < ActionController::API
  def index 
    comments = Micropost.find(params[:micropost_id]).comments.map do |comment|
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
  end
  
  def create
    comment = Comment.create!(comment_params)
    micropost = comment.micropost
    micropost.create_notification_comment!(comment.user, comment.id, micropost)
    render status: 201, json: { id: comment.id }
  
  end

  def destroy
    Comment.find(params[:id]).destroy!
    head :ok
  end
  
  private

  def comment_params
    params.require(:comment).permit(:micropost_id, :user_id, :content)
  end
end