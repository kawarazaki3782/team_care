class GuestSessionsController < ApplicationController
  def create
    if user = User.find_or_create_by!(email:"guest@exapmle.com",gender:"男性",long_teamcare:"介護者") do |user|
      user.password = SecureRandom.urlsafe_base64
      user.name = "ゲストユーザー"
      end
      session[:user_id] = user.id
      flash[:success] = "ゲストユーザーとしてログインしました"
      redirect_to root_path
    else
      flash[:danger] = "ログインに失敗しました"
      redirect_to root_path
    end
  end
end