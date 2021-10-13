# frozen_string_literal: true

module Members
  class LikesController < ApplicationController
    def create
      like = current_member.likes.new(request_id: params[:request_id])
      like.save
      @request = Request.find(params[:request_id])
      @request.create_notification_like!(current_member) if @request.member_id != current_member.id
    end

    def destroy
      @request = Request.find(params[:request_id])
      like = current_member.likes.find_by(request_id: @request.id)
      like.destroy
    end

    def index
      member = current_member
      likes_request = member.likes.select(:request_id)
      @requests = Request.where(params[request_id: likes_request]).page(params[:page]).reverse_order
      # binding.pry
    end
  end
end
