class ApplicationController < ActionController::Base
  include SessionsHelper

  def about; end

  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = 'ログインしてください'
      redirect_to login_url
    end
  end

  def blocking_user
    @user = User.find(params[:id])
    blocker_blocks = current_user.blocker_blocks
    blocker_blocks.each do |b|
      if b.blocker_id == @user.id
        flash[:danger] = 'このページにはアクセスできません'
        redirect_to root_url
      end
    end
  end

  def guest_user
    @user = User.find_by(email: 'guest@example.com')
    if @user.id == current_user.id       
        flash[:danger] = 'ゲストユーザーは編集・投稿が出来ません'
        redirect_to root_url
    end
  end

  private

  def current_user_set
    @user = current_user
  end
end
