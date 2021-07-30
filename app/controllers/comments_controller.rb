class CommentsController < ApplicationController
  def create
    @comment = Comment.new(comment_params)
    @comment.user_id = current_user.id
    @micropost = @comment.micropost
    @diary = @comment.diary
    @comment.save
      unless params[:micropost_id].nil? 
        @micropost.create_notification_comment!(current_user, @comment.id)
          redirect_back(fallback_location: root_path)
      end
      unless params[:diary_id].nil?
        @diary.create_notification_comment!(current_user, @comment.id)
        redirect_back(fallback_location: root_path)
      end
  end
  
  def destroy
    unless  params[:diary_id].nil?
      Comment.find(params[:id]).destroy
      redirect_back(fallback_location: root_path)
    end 
    unless  params[:micropost_id].nil?
      Comment.find(params[:id]).destroy
      redirect_back(fallback_location: root_path)
    end   
  end

  private

  def comment_params
    params.require(:comment).permit(:content, :micropost_id, :diary_id, :user_id)
  end
end
