class CategoriesController < ApplicationController
  before_action :set_category, only: [:show, :destroy]

  def new
    @category = Category.new
  end

  def show
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
    if @category.destroy
      flash[:danger] = "カテゴリーを削除しました"
      redirect_to categories_path
    else 
      flash[:danger] = "カテゴリーを削除できませんでした"
    end
  end
  
  private
  
  def category_params
    params.require(:category).permit(:name, :user_id)
  end

  def set_category
    @category = Category.find(params[:id])
  end
end
