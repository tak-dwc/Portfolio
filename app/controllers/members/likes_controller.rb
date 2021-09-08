class Members::LikesController < ApplicationController
  def create
    @request = Request.find(params[:request_id])
    like = current_member.likes.new(request_id: @request.id)
    like.save
  end
  
  def destroy
    @request = Request.find(params[:request_id])
    like = current_member.likes.find_by(request_id: @request.id)
    like.destroy
  end
end
