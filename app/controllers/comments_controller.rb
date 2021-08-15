class CommentsController < ApplicationController
  def create
    @comment = Comment.new(comment_params)
    @comment.user_id = current_user.id
    @micropost = @comment.micropost
    @diary = @comment.diary
    if @micropost.nil? && @diary.nil?
      flash[:danger] = 'コメントを投稿できませんでした'
      redirect_to root_path
    else
      if @comment.save
        redirect_back(fallback_location: root_path)
        flash[:success] = 'コメントが投稿されました'
      else
        redirect_back(fallback_location: root_path)
        flash[:danger] = 'コメントを入力してください'
      end
    end

    if @diary.present? && @micropost.nil?  
      @diary.create_notification_comment!(current_user, @comment.id, @diary)
    elsif  @micropost.present? && @diary.nil?
      @micropost.create_notification_comment!(current_user, @comment.id, @micropost)
    else
      flash[:danger] = 'コメントを投稿できませんでした'
    end
  end

  def destroy
    if params[:micropost_id].nil? && params[:diary_id].nil?
      flash[:danger] = 'コメントが削除できませんでした'
      redirect_to root_path
    else
      begin
        Comment.find(params[:id]).destroy
        redirect_back(fallback_location: root_path)
        flash[:danger] = 'コメントが削除されました'
      rescue
        flash[:danger] = 'コメントが削除できませんでした'
        redirect_to root_path
      end
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content, :micropost_id, :diary_id, :user_id)
  end
end
