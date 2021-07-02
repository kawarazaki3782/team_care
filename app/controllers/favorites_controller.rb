class FavoritesController < ApplicationController
  def index
    @user = current_user
    if params[:diary_id].nil?
      @micropost = @user.micropost_ids
      favorites = Favorite.where(user_id: current_user.id).order(created_at: :desc).pluck(:micropost_id) # ログイン中のユーザーのお気に入りのpost_idカラムを取得
      @favorites = Micropost.find(favorites) 
      

    elsif params[:micropost_id].nil?
      @diary = @user.diary_ids
      favorites = Favorite.where(user_id: current_user.id).order(created_at: :desc).pluck(:diary_id) # ログイン中のユーザーのお気に入りのpost_idカラムを取得
      @favorites = Diary.find(favorites) 

    else 
      redirect_to current_user
    end
  end

  def create
    @user = current_user
    if params[:micropost_id].nil?
       @diary = Diary.find(params[:diary_id])
       @favorite = current_user.favorites.create!(diary_id: @diary.id)
       redirect_back(fallback_location: root_path)
    elsif params[:diary_id].nil?
       @micropost = Micropost.find(params[:micropost_id])
       @favorite = current_user.favorites.create!(micropost_id: @micropost.id)
        redirect_back(fallback_location: root_path)
    else
        redirect_to current_user
    end     
  end

  def destroy
    if params[:micropost_id].nil?
      @favorite = Favorite.find_by(diary_id: params[:diary_id], user_id: current_user.id)
      @favorite.destroy
      redirect_back(fallback_location: root_path)
      
    elsif params[:diary_id].nil?
      @favorite = Favorite.find_by(micropost_id: params[:micropost_id], user_id: current_user.id)
      @favorite.destroy
      redirect_back(fallback_location: root_path)
  
    else
      redirect_to current_user
    end   
  end
end
