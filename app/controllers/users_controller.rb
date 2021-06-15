class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy
  
  def verification
    @user = User.find(params[:id])
    @user.attributes = user_params

    # 戻るときはエラーチェックしない
    if params[:back]
      render 'edit'
      return
    end

    # エラーがあれば編集画面へ戻す
    unless @user.valid?
      render 'edit'
      return
    end

    if params[:save]
      if @user.save
        # updateへリダイレクト 
        # リダイレクトするのは、F5などでブラウザのリロードで
        # 保存処理が二重に動かないようにするため
        render 'update'
      else
        # DBへの保存に失敗
        # 編集画面へ戻す
        render 'edit'
      end
    end 

  def update
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end

  def index
    @users = User.paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def confirm
    @user = User.new(user_params)
    render 'new' if @user.invalid?
  end

  def create
    @user = User.new(user_params)
    if params[:back]
      render 'new' 
    elsif @user.save
      log_in @user
      flash[:success] = "新規登録が完了しました"
      redirect_to @user
    else
      render 'new'
    end
    end
  end 
  
  def edit
  end

 

private
    
  def user_params
    params.require(:user).permit(:name, :email, :profile_image, :password, :password_confirmation, :gender, :birthday, :address, :long_teamcare, :profile, :profile_image_cache)
  end

  # ログイン済みユーザーかどうか確認
  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "Please log in."
      redirect_to login_url
    end
  end

  # 正しいユーザーかどうか確認
  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end

  # 管理者かどうか確認
  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end
end