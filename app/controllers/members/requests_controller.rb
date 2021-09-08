class Members::RequestsController < ApplicationController

  def new
    @request = Request.new
  end

  def create
    @request = Request.new(request_params)
    @request.member_id = current_member.id
    if @request.save
      redirect_to request_path(@request)
    else
      render :new
    end
  end

  def index
    @requests = Request.all
  end

  def show
    @request = Request.find(params[:id])
    @comment = Comment.new
    @comments = @request.comments.order(created: :desc)
  end

  def edit
    @request = Request.find(params[:id])
  end
  
  def update
    @request = Request.find(params[:id])
    if @request.update(request_params)
      redirect_to request_path(@request)
    else
      render :edit
    end  
  end

  def destroy
    @request = Request.find(params[:id])
    @request.destroy
    redirect_to requests_path
  end

  private
  def request_params
    params.require(:request).permit(:schedule, :content, :location, :is_active,:member_id)
  end
end
