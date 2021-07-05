class MicropostsController < ApplicationController
    before_action :logged_in_user, only: [:create, :destroy]
    before_action :ensure_correct_user,   only: :destroy
    # before_action :authenticate_user?, only: [:show, :create]
    
    def index
      @microposts = current_user.microposts.all.order("created_at DESC").page(params[:page]).per(5)
      @user = current_user
      @like = Like.new
    end

    def new
      @micropost = Micropost.new
    end
    
    def show
      @micropost = Micropost.find(params[:id])
      @comments = @micropost.comments
      @comment = Comment.new
      @like = Like.new
    end

    def create
      @micropost = Micropost.new(micropost_params)
      @micropost.user_id = current_user.id
        if @micropost.save!
          flash[:success] = "つぶやきを投稿しました。"
          redirect_to microposts_path
        else
          @feed_items = current_user.feed.paginate(page: params[:page])
          redirect_to root_url
        end
    end

    
    def search
      #Viewのformで取得したパラメータをモデルに渡す
      @microposts = Micropost.search(params[:search]).page(params[:page]).per(5)
    end
    

    def destroy
      @micropost.destroy
      flash[:success] = "つぶやきを削除しました"
      redirect_to request.referrer || root_url
    end
    
      private
    
        def micropost_params
          params.require(:micropost).permit(:content, :post_image, :category_id, :user_id)
        end

        # def correct_user
        #     @micropost = current_user.microposts.find_by(id: params[:id])
        #     redirect_to root_url if @micropost.nil?
        # end

        def ensure_correct_user
          @micropost = Micropost.find_by(id: params[:id])
          if @micropost.user_id != @current_user.id
          flash[:notice] = "権限がありません"
          redirect_to("/posts/index")
          end
        end
 end

