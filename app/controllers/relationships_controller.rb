class RelationshipsController < ApplicationController
  before_action :logged_in_user

  def create
    @user = User.find(params[:followed_id])
    if current_user.follow(@user)
      @user.create_notification_follow!(current_user)
      respond_to do |format|
        format.html { redirect_to @user }
        format.js
      end
    else
      flash[:danger] = "フォローできませんでした"
      redirect_back(fallback_location: root_path)
     end
    end

  def destroy
    @user = Relationship.find(params[:id]).followed
    if current_user.unfollow(@user)
      respond_to do |format|
        format.html { redirect_to @user }
        format.js
      end
    else
      flash[:danger] = "フォローを解除できません"
      redirect_back(fallback_location: root_path)
    end
   end
end

