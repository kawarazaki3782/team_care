class ApplicationController < ActionController::Base
    include SessionsHelper
    before_action :set_q
    
    def about
    end
    
  
    def set_q
      @q = Micropost.ransack(params[:q])
    end

  
      # ユーザーのログインを確認する
      def logged_in_user
        unless logged_in?
          store_location
          flash[:danger] = "Please log in."
          redirect_to login_url
        end
      end


    #   def block_in_user
    #     @user = User.find params[:blocked_id]
    #     unless @user.blocked_id.nil?
    #     store_location
    #     flash[:danger] = "このページにはアクセスできません"
    #     redirect_to root_url
    #   end
    # end
end
