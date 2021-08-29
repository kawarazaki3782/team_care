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
end
