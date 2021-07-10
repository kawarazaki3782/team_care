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
 

      def block_in_user
        @user = User.find(params[:id])
        blocker_blocks = current_user.blocker_blocks
        blocker_blocks.each do |b| 
          if b.blocker_id == @user.id
          flash[:danger] = "このページにはアクセスできません"
          redirect_to root_url
          end
        end
      end
end
