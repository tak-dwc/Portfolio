class Admins::RequestsController < ApplicationController
   before_action :authenticate_member!,except: [:index,:show]

  def index
    @requests = Request.page(params[:page]).reverse_order
  end

  def show
    @request = Request.find(params[:id])
    @comment = Comment.new
    @comments = @request.comments.order(created: :desc)
    @request_tags = @request.tags
  end
  
  def edit 
    
  end
  
  def update 
  
  end  
  
  private 
  def request_params
    params.require(:request).permit(:title, :schedule, :content, :location, :is_active, :member_id,:caption)
  end  
end
