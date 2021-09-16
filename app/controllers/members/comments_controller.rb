# frozen_string_literal: true

module Members
  class CommentsController < ApplicationController

    def create
      # @comment = Comment.new(comment_params)
      # @request = @comment.request
      # if @comment.save
      #   # ここから
      #   @request.create_notification_comment!(current_member, @comment.id)
      #   # ここまで
      #   respond_to do |format|
      #   format.html {redirect_to request.referrer}
      #   format.js
      #   end
      # end

      @request = Request.find(params[:request_id])
      @comment = @request.comments.build(comment_params) # build→request.idを持った状態でコメントnewをする
      @comment.member_id = current_member.id
      @comment.save
      @request.create_notification_comment!(current_member, @comment.id) if @request.member_id != current_member.id
    end

    def destroy
      @comment = Comment.find(params[:id])
      @comment.destroy
    end

    private

    def comment_params
      params.require(:comment).permit(:comment, :member_id, :request_id)
    end
  end
end
