class StaticPagesController < ApplicationController
  def home
    if logged_in?
        @users = User.all
        @microposts = Micropost.all.page(params[:page]).per(3)
        @diaries = Diary.all.page(params[:page]).per(3)
        # unless Micropost.find(Like.group(:micropost_id).order('count(micropost_id) desc').limit(5).pluck(:micropost_id)) == "[]"
          @micropost_ranks = Micropost.last_week
        # end
        # unless Diary.find(Like.group(:diary_id).order('count(diary_id) desc').limit(5).pluck(:diary_id)) == "[]"
          @diary_ranks = Diary.diary_last_week
        # end
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
