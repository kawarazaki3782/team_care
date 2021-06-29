class DiariesController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :ensure_correct_user,   only: :destroy

    def  new
        @diary = Diary.new
    end

    def  index
        
    end
    
    def  create
      @diary = Diary.new(diary_params)
      @diary.user_id = current_user.id
        if @diary.save
          flash[:success] = "日記を投稿しました。"
          redirect_to diaries_path
        else
          @feed_items = current_user.feed.paginate(page: params[:page])
          redirect_to root_url
        end  
    end

    def  show
      @diary = Diary.find(params[:id])
      @comments = @diary.comments
      @comment = Comment.new
      @user = current_user
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

    def  destory
      @diary.destroy
      flash[:success] = "日記を削除しました"
      redirect_to request.referrer || root_url
    end

    private
    
        def diary_params
          params.require(:diary).permit(:content, :diary_image, :category_id, :user_id, :title, :diary_image_cache )
        end

end
