class Api::Diary::FavoritesController < ActionController::API
  
  def  show
    args = { user_id: params[:user_id], diary_id: params[:diary_id] }

    if Favorite.exists?(args)
      render json: { id: Favorite.find_by!(args).id}
    else
      render json: { id: nil }
    end
  end

  def  create
    favorite = Favorite.create!(favorite_params)
    render status: 201, json: { id: favorite.id }
  end

  def  destroy
    Favorite.find(params[:id]).destroy!
    head :ok 
  end

  private 

  def favorite_params
    params.require(:favorite).permit(:user_id, :diary_id)
  end
end