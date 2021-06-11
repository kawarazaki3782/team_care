class UsersController < ApplicationController
  
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
      flash[:success] = "新規登録が完了しました"
      redirect_to @user
    else
      render 'new'
    end
   end
  end

private
    
  def user_params
    params.require(:user).permit(:name, :email, :profile_image, :password, :password_confirmation, :gender, :birthday, :address, :long_teamcare, :profile)
  end
