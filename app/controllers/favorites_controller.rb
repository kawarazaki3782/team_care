class FavoritesController < ApplicationController
  def index
    @user = current_user
    
    if params[:micropost_id].present? && params[:diary_id].nil?
      @micropost = @user.micropost_ids
      favorites = Favorite.where(user_id: current_user.id).order(created_at: :desc).pluck(:micropost_id)
      return @favorites = Micropost.where(id: favorites)
    elsif params[:diary_id].present? && params[:micropost_id].nil?
      @diary = @user.diary_ids
      favorites = Favorite.where(user_id: current_user.id).order(created_at: :desc).pluck(:diary_id) 
      return @favorites = Diary.where(id: favorites)
    else 
      flash[:danger] = "お気に入りに登録されていません"
      redirect_back(fallback_location: root_path)
    end
  end

  def create
    @user = current_user
    if  params[:diary_id].present? && params[:micropost_id].nil?
      @diary = Diary.find(params[:diary_id])
      @favorite = current_user.favorites.create!(diary_id: @diary.id)
      redirect_back(fallback_location: root_path)
    elsif  params[:micropost_id].present? && params[:diary_id].nil?
      @micropost = Micropost.find(params[:micropost_id])
      @favorite = current_user.favorites.create!(micropost_id: @micropost.id)
      redirect_back(fallback_location: root_path)
    else
      flash[:danger] = "お気に入りに登録できません"
      redirect_back(fallback_location: root_path)
    end
  end

  def destroy
    if  params[:diary_id].present? && params[:micropost_id].nil?
      @favorite = Favorite.find_by(diary_id: params[:diary_id], user_id: current_user.id)
      @favorite.destroy
      redirect_back(fallback_location: root_path) 
    elsif  params[:micropost_id].present? && params[:diary_id].nil?
      @favorite = Favorite.find_by(micropost_id: params[:micropost_id], user_id: current_user.id)
      @favorite.destroy
      redirect_back(fallback_location: root_path)
    else
      flash[:danger] = "お気に入りの登録を解除できません"
      redirect_back(fallback_location: root_path)
    end
  end
end
