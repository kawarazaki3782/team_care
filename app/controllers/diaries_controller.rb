class DiariesController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :ensure_correct_user2,   only: :destroy

    def  new
        @diary = Diary.new
    end

    def  index
      @user = current_user
      @diary = Diaries.published,current_user.microposts.all.page(params[:page]).per(5)
      @like = Like.new
        
    end
    
    def  create
      @diary = Diary.new(diary_params)
      @diary.user_id = current_user.id
        if @diary.save!
          flash[:success] = "日記を投稿しました。"
          redirect_to diaries_path
        else
          @feed_items = current_user.feed.paginate(page: params[:page])
          redirect_to root_url
        end  
    end

    def  show
      @diary = Diary.find(params[:id])
      require_login if @diary.draft?
      @comments = @diary.comments
      @comment = Comment.new
      @like = Like.new  
    end

    def  edit
      @diary = Diary.find(params[:id])
    end

    def update
      @diary = Diary.find(params[:id])
      if @diary.update(diary_params)
        redirect_to root_url
      else
        render 'new'
      end
    end

    def destroy
      @diary.destroy
      flash[:success] = "日記を削除しました"
      redirect_to root_url
    end

    private
    
        def diary_params
          params.require(:diary).permit(:content, :diary_image, :category_id, :user_id, :title, :diary_image_cache, :status)
        end

        def ensure_correct_user2
          @diary = Diary.find_by(id: params[:id])
          if @diary.user_id != @current_user.id
          flash[:notice] = "権限がありません"
          redirect_to("/diaries/index")
          end
        end

        def require_login
          redirect_to login_path if !logged_in?
        end

end
