class DiariesController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :ensure_correct_user_diary,only: :destroy
  before_action :set_diary, only: [:show, :edit, :update]

  def draft 
    @user = current_user
    @diaries = Diary.where(user_id: current_user.id,status: :draft).order("created_at DESC").all.page(params[:page]).per(5)
  end  
  
  def new
    @diary = Diary.new
  end

  def index
    @user = current_user
    @diaries = Diary.where(user_id: current_user.id,status: :published).order("created_at DESC").all.page(params[:page]).per(5)
    @like = Like.new
  end
    
  def create
    @diary = Diary.new(diary_params)
    @diary.user_id = current_user.id
      if @diary.save!
        flash[:success] = "日記を投稿しました"
        redirect_to diaries_path
      else
        flash[:danger] = "日記が投稿できません"
        redirect_back(fallback_location: root_path)
      end  
  end

  def show
    require_login if @diary.draft?
    @comments = @diary.comments
    @comment = Comment.new
    @like = Like.new  
  end

  def edit;end

  def update
    if @diary.update(diary_params)
      flash[:success] = "日記の編集が完了しました"
      redirect_to diaries_path
    else
      flash[:danger] = "日記を編集できません"
      render 'edit'
    end
  end

  def destroy
    if @diary.destroy
      flash[:danger] = "日記を削除しました"
      redirect_to diaries_path
    else
      flash[:danger] = "日記を削除できません"
      redirect_to diaries_path
    end
  end

  private  
  def diary_params
    params.require(:diary).permit(:content, :diary_image, :category_id, :user_id, :title, :diary_image_cache, :status)
  end

  def ensure_correct_user_diary
    @diary = Diary.find_by(id: params[:id])
      if @diary.user_id != @current_user.id
        flash[:notice] = "権限がありません"
        redirect_to("/diaries/index")
      end
  end

  def require_login
    redirect_to login_path if !logged_in?
  end
  
  def set_diary
    @diary = Diary.find(params[:id])
  end
end
