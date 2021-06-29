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
      @comment = Comment.find(params[:id])
      @micropost = Micropost.find(params[:micropost_id])
      @diary = Diary.find(params[:diary_id])

      if @micropost.present?
        if @comment.user_id = current_user.id
          Comment.find_by(id: params[:id],micropost_id: params[:micropost_id]).destroy
          redirect_to microposts_path
    
        elsif @diary.present?
          if @comment.user_id = current_user.id
            Comment.find_by(id: params[:id],diary_id: params[:diary_id]).destroy
            redirect_to diaries_path
        else
        redirect_to current_user_path
         end
        end
        end
      end
    
      private
      def comment_params
        params.require(:comment).permit(:content, :micropost_id, :diary_id)
      end

    
end
