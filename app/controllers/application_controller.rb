class ApplicationController < ActionController::Base
  include SessionsHelper
    
  def about
  end

   # ユーザーのログインを確認する
  def logged_in_user
     unless logged_in?
       store_location
       flash[:danger] = "Please log in."
       redirect_to login_url
     end
  end

  def block_in_user
    @user = User.find(params[:id])
    blocker_blocks = current_user.blocker_blocks
    blocker_blocks.each do |b| 
      if b.blocker_id == @user.id
        flash[:danger] = "このページにはアクセスできません"
        redirect_to root_url
      end
    end
  end

  def guest_user
    @user = User.find_by(email: 'guest@example.com')
      if @user == current_user
        flash[:danger] = 'ゲストユーザーは編集・投稿が出来ません'
        redirect_to root_url
      end
  end
end
