class CommentsController < ApplicationController
  def create
    @comment = Comment.new(comment_params)
    @comment.user_id = current_user.id
    @micropost = @comment.micropost
    @diary = @comment.diary
      if @comment.save
        flash[:success] = "コメントが投稿されました"
      else
        flash[:error] = "コメントが作成できません"
        redirect_back(fallback_location: root_path)
      end

      if params[:micropost_id].nil? 
        flash[:error] = "コメントが作成できません"
        redirect_back(fallback_location: root_path)
      else
        @micropost.create_notification_comment!(current_user, @comment.id)
        redirect_back(fallback_location: root_path)
      end
      if params[:diary_id].nil?
        flash[:error] = "コメントが作成できません"
        redirect_back(fallback_location: root_path)
      else
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
