class GuestSessionsController < ApplicationController
  def create
    if  user = User.find_or_create_by!(email: 'guest@example.com', gender: '男性', long_teamcare: '介護者') do |user|
      user.password = SecureRandom.urlsafe_base64
      user.name = 'ゲストユーザー'
      user.profile_image = Pathname.new(Rails.root.join("app/assets/images/default.jpg")).open
    end
      session[:user_id] = user.id
      flash[:success] = 'ゲストユーザーとしてログインしました'
    else
      flash[:danger] = 'ログインに失敗しました'
    end
    redirect_to root_path
  end
end
