class FavoritesController < ApplicationController
  before_action :current_user_set, only: %i[show index]

  def index
    if params[:micropost_id].present? && params[:diary_id].nil?
      @micropost = @user.micropost_ids
      microposts = Favorite.micropost_favorites(current_user.id)
      @microposts = Micropost.where(id: microposts)
    elsif params[:diary_id].present? && params[:micropost_id].nil?
      @diary = @user.diary_ids
      diaries = Favorite.diary_favorites(current_user.id)
      @diaries = Diary.where(id: diaries)
    else
      flash[:danger] = 'お気に入りに登録されていません'
      redirect_back(fallback_location: root_path)
    end
  end

  def create
    if params[:diary_id].present? && params[:micropost_id].nil?
      begin
        @diary = Diary.find(params[:diary_id])
        @favorite = current_user.favorites.create!(diary_id: @diary.id)
      rescue
        flash[:danger] = '日記が削除されました'
        redirect_to root_path
      end
    elsif params[:micropost_id].present? && params[:diary_id].nil?
      begin
        @micropost = Micropost.find(params[:micropost_id])
        @favorite = current_user.favorites.create!(micropost_id: @micropost.id)
      rescue
        flash[:danger] = 'つぶやきが削除されました'
        redirect_to root_path
      end
    else
      flash[:danger] = 'お気に入りに登録できません'
    end
  end

  def destroy
    if params[:diary_id].present? && params[:micropost_id].nil?
      @favorite = Favorite.find_by(diary_id: params[:diary_id], user_id: current_user.id)
      @favorite.destroy
    elsif params[:micropost_id].present? && params[:diary_id].nil?
      @favorite = Favorite.find_by(micropost_id: params[:micropost_id], user_id: current_user.id)
      @favorite.destroy
    else
      flash[:danger] = 'お気に入りの登録を解除できません'
    end
    redirect_back(fallback_location: root_path)
  end
end
