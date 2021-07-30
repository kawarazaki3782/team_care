class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :destroy,  :following, :followers]
  before_action :correct_user, only: :edit
  before_action :admin_user, only: :destroy
  before_action :block_in_user, only: :show
  
  def show
    if logged_in? && current_user.id.to_s == params[:id]
      @user = User.find(params[:id])
      @micropost = @user.micropost_ids
      @diary = @user.diary_ids
      @rooms = @user.rooms
      @currentUserEntry=Entry.where(user_id: current_user.id)
      @userEntry=Entry.where(user_id: @user.id)
        @currentUserEntry.each do |cu|
          @userEntry.each do |u|
            if cu.room_id == u.room_id then
              @isRoom = true
              @roomId = cu.room_id
            end
         end
       end
      if @isRoom
      else
        @room = Room.new
        @entry = Entry.new
      end
    end
    if logged_in? && current_user.id.to_s != params[:id]
      @user = User.find(params[:id])
      @microposts = @user.microposts.order(created_at: :desc).page(params[:page]).per(3)
      @diaries = @user.diaries.order(created_at: :desc).page(params[:page]).per(3)
      @currentUserEntry=Entry.where(user_id: current_user.id)
      @userEntry=Entry.where(user_id: @user.id)
        @currentUserEntry.each do |cu|
          @userEntry.each do |u|
            if cu.room_id == u.room_id then
              @isRoom = true
              @roomId = cu.room_id
            end
          end
        end
        if @isRoom
        else
          @room = Room.new
          @entry = Entry.new
        end
      end
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
    flash[:danger] = "User deleted"
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
    @user  = User.find(params[:id])
    @users = @user.following.page(params[:page]).per(5)
    render 'show_followed'
  end

  def followers
    @user  = User.find(params[:id])
    @users = @user.followers.page(params[:page]).per(5)
    render 'show_follower'
  end

  def blocking
    @user = User.find(params[:id])
    @users = @user.blocking.page(params[:page]).per(5)
    render 'show_blocking'
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
