class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy,  :following, :followers]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy
  
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

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
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
  

  def edit
  end

  def verification
    @user = User.find(params[:id])
    @user.attributes = user_params
    logger.debug "task: #{@user.inspect}"

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

  #   if params[:save]
  #     if @user.update(user_params)
  #       # updateへリダイレクト 
  #       # リダイレクトするのは、F5などでブラウザのリロードで
  #       # 保存処理が二重に動かないようにするため
  #       redirect_to action: :update
  #     else
  #       # DBへの保存に失敗
  #       # 編集画面へ戻す
  #       render 'edit'
  #     end
  #   end
  # end 

    
    if params[:save]
      logger.debug "task: #{@user.profile_image.inspect}"
      if @user.profile_image !=  User.find(params[:id]).profile_image
         @user.update(user_params)
        redirect_to action: :update
      
      elsif User.update_except_for_image_path(user_params)
          #profile_image以外をupdate
          redirect_to action: :update
      else
          render 'edit'
      end
    end
  end


      

  def update
  end

  def index
    @users = User.paginate(page: params[:page])
  end

  def following
    @title = "Following"
    @user  = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user  = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

    private

    def user_params
      params.require(:user).permit(:name, :email, :profile_image, :password, :password_confirmation, :gender, :birthday, :address, :long_teamcare, :profile, :profile_image_cache)
    end

    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end

    def correct_user
      @user = User.find(params[:id])
      logger.debug "task: #{@user.inspect}"
      redirect_to(root_url) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
