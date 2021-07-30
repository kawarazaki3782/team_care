class BlocksController < ApplicationController
  
  def create
    @user =User.find(params[:block][:blocked_id])
    current_user.block(@user)
    respond_to do |format|
      format.html {redirect_to @user, flash: {success: 'ブロックしました'} }
      format.js
    end
  end
    
  def destroy
    @user = User.find(params[:block][:blocked_id])
    current_user.unblock(@user)
      respond_to do |format|
        format.html {redirect_back(fallback_location: root_url)}
        format.js
      end
  end
end
    

