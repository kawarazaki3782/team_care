class LikesController < ApplicationController
  def create
    unless params[:diary_id].nil?
      @diary = Diary.find(params[:diary_id])
      @like = current_user.likes.create!(diary_id: @diary.id)
      @diary.create_notification_by(current_user)
      redirect_back(fallback_location: root_path)
    end
    unless params[:micropost_id].nil?
      @micropost = Micropost.find(params[:micropost_id])
      @like = current_user.likes.create!(micropost_id: @micropost.id)
      @micropost.create_notification_by(current_user)
      redirect_back(fallback_location: root_path)
    end
  end
      
  def destroy
    unless params[:diary_id].nil?
      @like = Like.find_by(diary_id: params[:diary_id], user_id: current_user.id)
      @like.destroy
      redirect_back(fallback_location: root_path)
    end
    unless params[:micropost_id].nil?
      @like = Like.find_by(micropost_id: params[:micropost_id], user_id: current_user.id)
      @like.destroy
      redirect_back(fallback_location: root_path)
    end
  end
end
