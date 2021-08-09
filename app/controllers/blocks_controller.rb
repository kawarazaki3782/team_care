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
     current_user.unblock(@user)
      respond_to do |format|
        format.html { redirect_back(fallback_location: root_url) }
        format.js
      end
  end

  private

  def set_block
    @user = User.find_by(id: params[:block][:blocked_id])
    unless @user
      flash[:danger] = 'ユーザーが削除されました'
      redirect_to root_path
    end
  end
end
