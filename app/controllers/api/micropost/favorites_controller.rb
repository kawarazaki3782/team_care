class Api::Micropost::FavoritesController < ActionController::API
  
  def  show
    @favorite =  Favorite.find(params[:favorite_id])
  end

  def  create
    @micropost = Micropost.find(params[:micropost_id])
    @favorite = current_user.favorites.create!(micropost_id: @micropost.id)
    head :created
  end

  def  destroy
    @favorite = Favorite.find_by(micropost_id: params[:micropost_id], user_id: current_user.id)
    @favorite.destroy
    head :ok 
  end
end