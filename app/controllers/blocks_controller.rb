class BlocksController < ApplicationController
  before_action :set_block, only: %i[create destroy]

  def create
      current_user.block(@user)
        respond_to do |format|
          format.html { redirect_to @user, flash: { success: 'ブロックしました' } }
          format.js
        end
  end

  def destroy
    if current_user.unblock(@user)
      respond_to do |format|
        format.html { redirect_back(fallback_location: root_url) }
        format.js
      end
    else
      flash[:danger] = 'ブロックを解除できません'
      redirect_back(fallback_location: root_path)
    end
  end

  private

  def set_block
    @user = User.find(params[:block][:blocked_id])
  end
end
