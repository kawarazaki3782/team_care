class LikesController < ApplicationController
    def create
         @micropost = Micropost.find(params[:micropost_id])
         @diary = Diary.find(params[:diary_id])
         
         
         @micropost = nil 
          @like = current_user.likes.create(diary_id: @diary.id)
            redirect_back(fallback_location: root_path)
        elsif  @diary = Diary.find(params[:diary_id])
          if @diary = nil 
          @like = current_user.likes.create(micropost_id: @micropost.id)
            redirect_back(fallback_location: root_path)
        end
         end
         end

    end
    
      def destroy
        @like = Like.find_by(micropost_id: params[:micropost_id], user_id: current_user.id)
        @like.destroy
        redirect_back(fallback_location: root_path)
      end
end
