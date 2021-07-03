class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :destroy,  :following, :followers]
  before_action :correct_user, only: :edit
  before_action :admin_user, only: :destroy
  
  def show
    @user = User.find(params[:id])
    @micropost = @user.micropost_ids
    @diary = @user.diary_ids
    # @favorites = Favorite.where(user_id: current_user.id).pluck(:diary_id) 
    # @favorite_diaries = current_user.favorite_diaries.includes(:user).order(created_at: :desc)
    # logger.debug "task: #{@favorites.inspect}"

    # @diary = @user.diary_ids
    # favorites = Favorite.where(user_id: current_user.id).pluck(:diary_id)  # ログイン中のユーザーのお気に入りのpost_idカラムを取得
    # @favorites = Diary.find(favorites) 
    
    # @microposts = @user.microposts.paginate(page: params[:page])
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
    @user.profile_image.cache!
    
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
      @user.profile_image.retrieve_from_cache! params[:cache][:profile_image]
        if @user.update(user_params)
        # updateへリダイレクト 
        # リダイレクトするのは、F5などでブラウザのリロードで
        # 保存処理が二重に動かないようにするため
        redirect_to :action => 'update' 
       else
        # DBへの保存に失敗
        # 編集画面へ戻す
        render 'edit'
       end
    end
  end 

  def update
    @user = User.find(params[:id])
  end

  def index
    @users = User.all.page(params[:page]).per(5)
  end

  def following
    @title = "Following"
    @user  = User.find(params[:id])
    @users = @user.following.page(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user  = User.find(params[:id])
    @users = @user.followers.page(page: params[:page])
    render 'show_follow'
  end

    private

    def user_params
      params.require(:user).permit(:name, :email, :profile_image, :password, :password_confirmation, :gender, :birthday, :address, :long_teamcare, :profile, :profile_image_cache)
    end


    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
