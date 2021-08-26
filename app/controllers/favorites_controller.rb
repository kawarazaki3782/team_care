class FavoritesController < ApplicationController
  before_action :current_user_set, only: %i[show index]

  def index
      @micropost = @user.micropost_ids
      microposts = Favorite.micropost_favorites(current_user.id)
      @microposts = Micropost.where(id: microposts).page(params[:page]).per(5)
      @diary = @user.diary_ids
      diaries = Favorite.diary_favorites(current_user.id)
      @diaries = Diary.where(id: diaries).page(params[:page]).per(5)
  end

  def  show
    @microposts = Favorite.micropost_favorites(current_user.id)
  end

  # def create
  #   if params[:diary_id].present? && params[:micropost_id].nil?
  #     begin
  #       @diary = Diary.find(params[:diary_id])
  #       @favorite = current_user.favorites.create!(diary_id: @diary.id)
  #       redirect_back(fallback_location: root_path)
  #     rescue
  #       flash[:danger] = '日記が削除されました'
  #       redirect_to root_path
  #     end
  #   elsif params[:micropost_id].present? && params[:diary_id].nil?
  #     begin
  #       @micropost = Micropost.find(params[:micropost_id])
  #       @favorite = current_user.favorites.create!(micropost_id: @micropost.id)
  #       redirect_back(fallback_location: root_path)
  #     rescue
  #       flash[:danger] = 'つぶやきが削除されました'
  #       redirect_to root_path
  #     end
  #   else
  #     flash[:danger] = 'お気に入りに登録できません'
  #   end
  # end

  # def destroy
  #   if params[:diary_id].present? && params[:micropost_id].nil?
  #     @favorite = Favorite.find_by(diary_id: params[:diary_id], user_id: current_user.id)
  #     @favorite.destroy
  #     redirect_back(fallback_location: root_path)
  #   elsif params[:micropost_id].present? && params[:diary_id].nil?
  #     @favorite = Favorite.find_by(micropost_id: params[:micropost_id], user_id: current_user.id)
  #     @favorite.destroy
  #     redirect_back(fallback_location: root_path)
  #   else
  #     flash[:danger] = 'お気に入りの登録を解除できません'
  #   end
  # end
end
