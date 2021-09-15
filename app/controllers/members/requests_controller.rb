# frozen_string_literal: true

module Members
  class RequestsController < ApplicationController
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
      @requests = Request.page(params[:page]).reverse_order
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

    def tagshow
    #タグリンク用
      @member = current_member
      @tag = Tag.find_by(name: params[:name])
      @requests = @tag.requests.page(params[:page]).reverse_order
    # タグ一覧
      if params[:name].nil?
        @tags = Tag.all.to_a.group_by{ |tag| tag.request.count}
      else
        @tag = Tag.find_by(name: params[:name])
        @request = @tag.requests.page(params[:page]).per(20).reverse_order
        @tags = Tag.all.to_a.group_by{ |tag| tag.requests.count}
      end
    end

    def is_active_release
      @request = Request.find(params[:request_id])
      # ステータス変更
      if @request.release?
        @request.in_transaction!
      end
      #ステータス変更を機にチャットルームの作成
      if @request.in_transaction?
        @member = Member.find(@request.member_id)
        @currentMemberEntry = Entry.where(member_id: current_member.id)
        @memberEntry = Entry.where(member_id: @member.id)
        unless @member.id == current_member.id
          if @currentMemberEntry.present? && @memberEntry.present?
            @currentMemberEntry.each do |current|
              @memberEntry.each do |member|
                if current.room_id == member.room_id then
                  @isRoom = true
                  @roomId = current.room_id
                end
              end
            end
          else
            @room = Room.create
            @entry1 = Entry.create(room_id: @room.id, member_id: current_member.id)
            @entry2 = Entry.create(room_id: @room.id, member_id: @member.id)
            redirect_to room_path(@room.id)
          end
        end
      else
        render :show
      end
    end

    private

    def request_params
      params.require(:request).permit(:title, :schedule, :content, :location, :is_active, :member_id,:caption)
    end

  end
end
