class RelationshipsController < ApplicationController
  before_action :logged_in_user

  def create
    begin
      @user = User.find(params[:followed_id])
      current_user.follow(@user)
      @user.create_notification_follow!(current_user)
      redirect_to @user
    rescue 
      flash[:danger] = 'ユーザーが削除されました'
      redirect_to root_path
    end
  end

  def destroy
    begin
      @user = Relationship.find(params[:id]).followed
      current_user.unfollow(@user)
      redirect_to @user
    rescue
      flash[:danger] = 'ユーザーが削除されました'
      redirect_to root_path
    end
  end
end
