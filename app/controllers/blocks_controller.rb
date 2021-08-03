class BlocksController < ApplicationController
  
  def create
    begin 
      @user = User.find(params[:block][:blocked_id])
      current_user.block(@user)
      respond_to do |format|
        format.html {redirect_to @user, flash: {success: 'ブロックしました'} }
        format.js
      end
    rescue ActiveRecord::RecordNotFound => e
      logger.error e 
      logger.error e.backtrace.join("\n") 
      flash[:alert] += 'ブロックできません'
    end
  end
    
  def destroy
    @user = User.find(params[:block][:blocked_id])
    if current_user.unblock(@user)
      respond_to do |format|
        format.html {redirect_back(fallback_location: root_url)}
        format.js
      end
    else 
      flash[:danger] = "ブロックを解除できません"
      redirect_back(fallback_location: root_path)
    end
  end
end
    

