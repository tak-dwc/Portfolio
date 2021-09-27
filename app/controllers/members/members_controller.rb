# frozen_string_literal: true

module Members
  class MembersController < ApplicationController
    def show
      @member = Member.find(params[:id])
      @requests = @member.requests.where(is_active: ['0','3']).all
    end

    def edit
      @member = Member.find(params[:id])
    end

    def update
      @member = Member.find(params[:id])
      if @member.update(member_params)
        redirect_to member_path(@member)
        flash[:success] = "プロフィール編集完了しました!"
      else
        render :edit
      end
    end

    def unsubscribe; end

    def withdraw
      @member = Member.find(params[:id])
      @member.update(is_deleted: true)
      reset_session
      redirect_to root_path
    end

    def main
      @member = Member.find(params[:id])
      @requests = @member.requests.where(is_active: ['0','3']).page(params[:page]).reverse_order
      # @requests = @member.requests.select(is_active: :release ,)
    end

    private

    def member_params
      params.require(:member).permit(:is_deleted, :last_name, :first_name, :last_name_kana, :first_name_kana, :nickname, :sex, :image, :hobby, :job, :introduction, :email)
    end
  end
end
