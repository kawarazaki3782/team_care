class MicropostsController < ApplicationController
  before_action :logged_in_user, only: %i[create destroy]
  before_action :ensure_correct_user, only: :destroy
  before_action :current_user_set, only: :index

  def index
    @microposts = current_user.microposts.all.order('created_at DESC').page(params[:page]).per(5)
    @like = Like.new
  end

  def new
    @micropost = Micropost.new
    if params[:template_id]
      @micropost.content = Template.find(params[:template_id]).content  
    end
  end

  def show
    if params[:id] == 'search'
      redirect_to root_path
      flash[:danger] = '再度検索をかけてください'
    else
      begin
        @micropost = Micropost.find(params[:id])
        @comments = @micropost.comments
        @comment = Comment.new
        @like = Like.new
      rescue
        redirect_to root_path
        flash[:danger] = 'つぶやきが削除されました'
      end
    end
  end

  def create
    @micropost = Micropost.new(micropost_params)
    @micropost.user_id = current_user.id
    if @micropost.save
      flash[:success] = 'つぶやきを投稿しました'
      redirect_to microposts_path
    else
      flash[:danger] = 'つぶやきの入力に不備があります'
      redirect_back(fallback_location: root_path)
    end
  end

  def search
    @microposts = Micropost.search(params[:search]).page(params[:page]).per(5)
  end

  def destroy
    flash[:danger] = @micropost.destroy ? "つぶやきを削除しました":"つぶやきの削除に失敗しました"
    redirect_to microposts_path
  end

  private

  def micropost_params
    params.require(:micropost).permit(:content, :post_image, :category_id, :user_id)
  end

  def ensure_correct_user
    @micropost = Micropost.find_by(id: params[:id])
    if @micropost.user_id != @current_user.id
      flash[:danger] = '権限がありません'
      redirect_to('/posts/index')
    end
  end
end
