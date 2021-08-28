class BlocksController < ApplicationController
  before_action :set_block, only: %i[create destroy]

  def create
    if current_user.block(@user)
      redirect_to @user, flash: { success: 'ブロックしました' } 
    else
      flash[:danger] = "ブロックできませんでした"
      redirect_back(fallback_location: root_path)
    end
  end

  def destroy
    current_user.unblock(@user)
    redirect_back(fallback_location: root_url) 
  end

  private

  def set_block
    @user = User.find_by(id: params[:block][:blocked_id])
    unless @user
      flash[:success] = 'ユーザーが削除されました'
      redirect_to root_path
    end
  end
end
