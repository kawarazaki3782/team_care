class RelationshipsController < ApplicationController
  before_action :logged_in_user

  def create
    begin
      @user = User.find(params[:followed_id])
      current_user.follow(@user)
      @user.create_notification_follow!(current_user)
        respond_to do |format|
          format.html { redirect_to @user }
          format.js
        end
    rescue 
      flash[:danger] = 'ユーザーが削除されました'
      redirect_to root_path
    end
  end

  def destroy
    begin
      @user = Relationship.find(params[:id]).followed
      current_user.unfollow(@user)
      respond_to do |format|
        format.html { redirect_to @user }
        format.js
      end
    rescue
      flash[:danger] = 'ユーザーが削除されました'
      redirect_to root_path
    end
  end
end
