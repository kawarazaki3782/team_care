class Api::Micropost::CommentsController < ActionController::API
  
  def create
    comment = Comment.create(comment_params)
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