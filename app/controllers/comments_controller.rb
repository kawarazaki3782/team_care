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
      @comment.save
      flash[:success] = 'コメントが投稿されました'
    end

    if @diary.present? && @micropost.nil?
      @diary.create_notification_comment!(current_user, @comment.id)
      redirect_back(fallback_location: root_path)
    elsif  @micropost.present? && @diary.nil?
      @micropost.create_notification_comment!(current_user, @comment.id)
      redirect_back(fallback_location: root_path)
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
