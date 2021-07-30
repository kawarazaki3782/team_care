class CategoriesController < ApplicationController
  def new
    @category = Category.new
  end

  def show
    @category = Category.find(params[:id])
    @microposts = Micropost.where(category_id: @category.id).order(created_at: :desc).page(params[:page]).per(3)
    @diaries = Diary.where(category_id: @category.id).order(created_at: :desc).page(params[:page]).per(3)
  end

  def create
    @category = Category.new(category_params)
    @category.user_id = current_user.id
      if @category.save
        flash[:success] = "カテゴリー登録が完了しました"
        redirect_to categories_path
      else
        render :new
      end
  end

  def index
    @categories = Category.all
  end

  def destroy
    @category = Category.find(params[:id])
    @category.destroy
    flash[:danger] = "カテゴリーを削除しました"
    redirect_to categories_path
  end
    
  private
  
  def category_params
    params.require(:category).permit(:name, :user_id)
  end
end
