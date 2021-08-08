class UsersController < ApplicationController
  before_action :logged_in_user, only: %i[index edit destroy following followers]
  before_action :correct_user, only: :edit
  before_action :admin_user, only: :destroy
  before_action :blocking_user, only: :show
  before_action :set_user, only: %i[show verification destroy update following followers blocking]
  
  def show
    if logged_in? && current_user.id.to_s == params[:id]
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
      begin 
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
    rescue ActiveRecord::RecordNotFound => e
      redirect_to :root
      flash[:danger] = "ユーザーが削除されました"
    end
    

  def new
    @user = User.new
  end

  def confirm
    @user = User.new(user_params)
    render 'new' if @user.invalid?
  end

  def destroy
    if @user.destroy
      flash[:danger] = "ユーザーを削除しました"
      redirect_to users_url
    else
      flash[:danger] = "ユーザーを削除できませんでした"
      redirect_to users_url
    end
  end

  def create
    @user = User.new(user_params)
      if params[:back]
        render 'new' 
      elsif params[:save]
        @user.save
        log_in @user
        flash[:success] = "新規登録が完了しました"
        redirect_to @user
      else
        flash[:danger] = "ユーザーを登録できませんでした"
        render 'new'
      end
  end
  
  def edit;end

  def verification
    @user.attributes = user_params
    @user.profile_image.cache!
      if params[:back]
         render 'edit'
         return
      end
      unless @user.valid?
        render 'edit'
      return
      end
      if params[:save]
        @user.profile_image.retrieve_from_cache! params[:cache][:profile_image]
      if @user.update(user_params)
        redirect_to :action => 'update' 
       else
        flash[:danger] = "ユーザーを編集できませんでした"
        render 'edit'
       end
     end
  end 

  def update;end

  def index
    @users = User.all.page(params[:page]).per(5)
  end

  def following
    @users = @user.following.page(params[:page]).per(5)
    render 'show_followed'
  end

  def followers
    @users = @user.followers.page(params[:page]).per(5)
    render 'show_follower'
  end

  def blocking
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

  def set_user
    @user = User.find(params[:id])
  end
end
