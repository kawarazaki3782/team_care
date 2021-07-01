class CommentsController < ApplicationController
    def create
        @comment = Comment.new(comment_params)
        @comment.user_id = current_user.id
        if @comment.save
          redirect_back(fallback_location: root_path)
        else
          redirect_back(fallback_location: root_path)
        end
    
    end

    def destroy
      if params[:micropost_id].nil?
        @comment = Comment.find_by(diary_id: params[:diary_id], user_id: current_user.id)
        @comment.destroy
        redirect_back(fallback_location: root_path)

      elsif params[:diary_id].nil?
        @comment = Comment.find_by(micropost_id: params[:micropost_id], user_id: current_user.id)
        @comment.destroy
        redirect_back(fallback_location: root_path)
    
      else
        redirect_to current_user
      end   

    end
    


      

      # if @micropost.present?
      #   if @comment.user_id = current_user.id
      #     Comment.find_by(id: params[:id],micropost_id: params[:micropost_id]).destroy
      #     redirect_to microposts_path
    
      #   elsif @diary.present?
      #     if @comment.user_id = current_user.id
      #       Comment.find_by(id: params[:id],diary_id: params[:diary_id]).destroy
      #       redirect_to diaries_path
      #   else
      #   redirect_to current_user_path
      #    end
      #   end
      #   end
      # end

      # if params[:micropost_id].nil?
      #   @comment = Comment.find_by(diary_id: params[:diary_id], user_id: current_user.id)
      #   @comment.destroy
      #   redirect_back(fallback_location: root_path)
    
      private
      def comment_params
        params.require(:comment).permit(:content, :micropost_id, :diary_id)
      end

    
end
