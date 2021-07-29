class StaticPagesController < ApplicationController
  def home
    if logged_in?
        @users = User.all
        @microposts = Micropost.all.page(params[:page]).per(3)
        @diaries = Diary.all.page(params[:page]).per(3)
        @micropost_ranks = Micropost.last_week
        @diary_ranks = Diary.diary_last_week
        @categories = Category.all
        unless @following_microposts == nil? && current_user.following_ids == nil?
          @following_microposts = Micropost.where(user_id: [*current_user.following_ids]).order("created_at DESC").page(params[:page]).per(3)
        end
        unless @following_diaries == nil?
          @following_diaries = Diary.where(user_id: [*current_user.following_ids]).order("created_at DESC").page(params[:page]).per(3)
        end
     end
   end
end
