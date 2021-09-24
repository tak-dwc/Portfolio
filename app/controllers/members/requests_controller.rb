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
        flash[:success] = "投稿完了しました!"
      else
        render :new
      end
    end

    def index
      @active_requests = Request.where(is_active: :release).where.not(member_id: current_member.id).page(params[:page]).reverse_order
    end

    def show
      @request = Request.find(params[:id])
      @comment = Comment.new
      @comments = @request.comments.order(created: :desc)
      @request_tags = @request.tags
    end

    def edit
      @request = Request.find(params[:id])
      # ステータス管理：編集用
      @delete_at =
        if @request.is_active == "release"
          ["in_transaction", "end_transaction"]
        elsif @request.is_active == "in_transaction"
          ["release", "end_transaction", "release_stop"]
        elsif @request.is_active == "end_transaction"
          ["release", "in_transaction", "release_stop"]
        elsif @request.is_active == "release_stop"
          ["in_transaction", "end_transaction"]
        end
    end

    def update
      @request = Request.find(params[:id])
      if @request.update(request_params)
        redirect_to request_path(@request)
        flash[:success] = "投稿編集完了しました!"
      else
        render :edit
      end
    end

    def destroy
      @request = Request.find(params[:id])
      if @request.room_id.present?
        Room.destroy(@request.room_id)
      end
      if @request.destroy
        redirect_to requests_path
        flash[:success] = "投稿削除しました!"
      else
        render :show
      end
    end

    def tagshow
      # タグリンク用
      @member = current_member
      @tag = Tag.find_by(name: params[:name])
      @requests = @tag.requests.where(is_active: :release).page(params[:page]).reverse_order
      # タグ一覧
      if params[:name].nil?
        @set_tags = Tag.all.to_a.group_by { |tag| tag.request.count }
      else
        @tag = Tag.find_by(name: params[:name])
        @request = @tag.requests.where(is_active: :release).page(params[:page]).reverse_order
        # @tags = Tag.all.to_a.group_by{ |tag| tag.requests.count}
      end
    end

    def is_active_release
      @request = Request.find(params[:request_id])
      # ステータス変更
      if @request.release?
        # binding.irb
        @request.in_transaction!
      end
      # ステータス変更を機にチャットルームの作成
      if @request.in_transaction?
        @member = Member.find(@request.member_id)
        @currentMemberEntry = Entry.where(member_id: current_member.id, request_id: @request.id)
        @memberEntry = Entry.where(member_id: @member.id, request_id: @request.id)
        if !(@member.id == current_member.id) && @currentMemberEntry.present? && @memberEntry.present?
          @currentMemberEntry.each do |current|
            @memberEntry.each do |member|
              if current.room_id == member.room_id
                @isRoom = true
                @roomId = current.room_id
                redirect_to room_path(@roomId)
              end
            end
          end
        else
          @room = Room.create
          @entry1 = Entry.create(room_id: @room.id, member_id: current_member.id, request_id: @request.id)
          @entry2 = Entry.create(room_id: @room.id, member_id: @member.id, request_id: @request.id)
          @request.update(room_id: @room.id)
          redirect_to room_path(@room.id)
          flash[:success] = "取引開始しました!"
        end
      else
        render :show
      end
    end

    private

    def request_params
      params.require(:request).permit(:title, :schedule, :content, :location, :is_active, :member_id, :caption)
    end
  end
end
