class Members::CommentsController < ApplicationController
  def create
    @request = Request.find(params[:request_id])
    @comment = @request.comments.build(comment_params) #build→request.idを持った状態でコメントnewをする
    @comment.member_id = current_member.id
    @comment.save
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
  end

  private

  def comment_params
    params.require(:comment).permit(:comment,:member_id,:request_id)
  end
end
