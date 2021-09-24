class Members::SearchesController < ApplicationController
  def search
    @model = params[:model]

    if @model == "Request"
      @requests = Request.where(is_active: :release).where.not(member_id: current_member.id).looks(params[:search]).page(params[:page]).reverse_order
    else
      @members = Member.where.not(id: current_member.id).looks(params[:search]).page(params[:page]).reverse_order
    end
  end
end
