# frozen_string_literal: true

module Members
  class RequestsController < ApplicationController
    def new
      @request = Request.new
    end

    def create
      @request = Request.new(request_params)
      @request.member_id = current_member.id
      tag_list = params[:request] [:tag_name].split(',')
      if @request.save
        @request.save_tag(tag_list)
        redirect_to request_path(@request)
      else
        render :new
      end
    end

    def index
      @requests = Request.page(params[:page]).reverse_order
      @tag_list = Tag.all

    end

    def show
      @request = Request.find(params[:id])
      @comment = Comment.new
      @comments = @request.comments.order(created: :desc)
      @request_tags = @request.tags
    end

    def edit
      @request = Request.find(params[:id])
      @tag_list = @request.tags.pluck(:name).join(',')
    end

    def update
      @request = Request.find(params[:id])
      tag_list = params[:request] [:tag_name].split(',')
      if @request.update_attributes(request_params)
        @request.save_tag(tag_list)
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
      params.require(:request).permit(:title, :schedule, :content, :location, :is_active, :member_id)
    end
  end
end
