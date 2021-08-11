class LikesController < ApplicationController
  def create
    unless params[:diary_id].nil?
      begin
        @diary = Diary.find(params[:diary_id])
        @like = current_user.likes.create!(diary_id: @diary.id)
        @diary.create_notification_by(current_user)
        redirect_back(fallback_location: root_path)
      rescue
        flash[:danger] = "日記が削除されました"
        redirect_to root_path
      end
    end

    unless params[:micropost_id].nil?
      begin 
        @micropost = Micropost.find(params[:micropost_id])
        @like = current_user.likes.create!(micropost_id: @micropost.id)
        @micropost.create_notification_by(current_user)
        redirect_back(fallback_location: root_path)
      rescue
        flash[:danger] = "つぶやきが削除されました"
        redirect_to root_path
      end
    end
    flash[:danger] = 'いいねできませんでした' if params[:micropost_id].nil? && params[:diary_id].nil?
  end

  def destroy
    unless params[:diary_id].nil?
      begin
        @like = Like.find_by(diary_id: params[:diary_id], user_id: current_user.id)
        @like.destroy
        redirect_back(fallback_location: root_path)
      rescue
        flash[:danger] = "日記が削除されました"
        redirect_to root_path
      end
    end
    unless params[:micropost_id].nil?
      begin
        @like = Like.find_by(micropost_id: params[:micropost_id], user_id: current_user.id)
        @like.destroy
        redirect_back(fallback_location: root_path)
      rescue
        flash[:danger] = "つぶやきが削除されました"
        redirect_to root_path
      end
    end
    flash[:danger] = 'いいねできませんでした' if params[:micropost_id].nil? && params[:diary_id].nil?
  end
end
