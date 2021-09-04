class TemplatesController < ApplicationController
  def  new
    @template = Template.new
  end
  
  def  index
    @templates = Template.all
  end

  def  create
    @template = Template.new(template_params)
    @template.user_id = current_user.id
    if @template.save
      flash[:success] = "テンプレートが作成されました"
      redirect_to templates_path
    else
      render 'new'
    end
  end

  def  destroy
    @template = Template.find(params[:id])
    if @template.user == current_user 
      @template.destroy!
      flash[:danger] = "テンプレートが削除されました"
      redirect_to templates_path
    else
      flash[:danger] = "テンプレートが削除できません"
      redirect_to templates_path
    end
  end

  private
  def template_params
    params.require(:template).permit(:content)
  end
end
