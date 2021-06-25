class ApplicationController < ActionController::Base
    include SessionsHelper
    before_action :set_q
    
    def about
    end


    def set_q
      @q = Micropost.ransack(params[:q])
    end

    private
  
      # ユーザーのログインを確認する
      def logged_in_user
        unless logged_in?
          store_location
          flash[:danger] = "Please log in."
          redirect_to login_url
        end
      end
end
