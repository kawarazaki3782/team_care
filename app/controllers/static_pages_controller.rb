class StaticPagesController < ApplicationController
  def home
    @users = User.all
    @microposts = Micropost.all.page(params[:page]).per(3)
      # @feed_items = current_user.feed.page(page: params[:page])
    end
  end
