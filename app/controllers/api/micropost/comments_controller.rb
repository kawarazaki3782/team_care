class Api::Micropost::CommentsController < ActionController::API
  
  def index 
    comments = Micropost.find(params[:micropost_id]).comments.map do |comment|
      {
        content: comment.content,
        created_at: comment.created_at,
        user_name: comment.user.name,
        user_profile_image: comment.user.profile_image.url
      }
    end
    render status: 200, json: comments
  end
  
  def create
    comment = Comment.create!(comment_params)
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