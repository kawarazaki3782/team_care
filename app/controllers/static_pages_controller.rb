class StaticPagesController < ApplicationController
  def home
    if logged_in?
      @users = User.all
      @microposts = Micropost.all.page(params[:page]).per(3)
      @diaries = Diary.all.page(params[:page]).per(3)
      @micropost_ranks = Micropost.like_top5_posts
      @diary_ranks = Diary.like_top5_diaries
      @categories = Category.all
      @following_microposts = Micropost.following_microposts(*current_user).page(params[:page]).per(3)
      @following_diaries = Diary.following_diaries(*current_user).page(params[:page]).per(3)
    end
  end
end
