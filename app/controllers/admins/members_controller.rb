# frozen_string_literal: true

module Admins
  class MembersController < ApplicationController
    before_action :authenticate_member!, except: [:index, :show, :edit, :update]
    def index
      @members = Member.page(params[:page]).per(8)
    end

    def show
      @member = Member.find(params[:id])
    end

    def edit
      @member = Member.find(params[:id])
    end

    def update
      @member = Member.find(params[:id])
      if @member.update(member_params)
        redirect_to admins_member_path(@member)
      else
        redirect_to request.referer, notice: "更新できませんでした"
      end
    end

    private

    def member_params
      params.require(:member).permit(:is_deleted, :last_name, :first_name, :last_name_kana, :first_name_kana, :nickname, :sex, :image, :hobby, :job, :introduction, :email)
    end
  end
end
