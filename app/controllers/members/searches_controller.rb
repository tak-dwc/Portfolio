class Members::SearchesController < ApplicationController
  def search
    @model = params[:model]
    @search = params[:search]

    if @model == "Request"
      @requests =  Request.release.exclude_member(current_member.id).search(params[:search]).page(params[:page]).reverse_order
      
      # 元 Request.where(is_active: :release).where.not(member_id: current_member.id).looks(params[:search]).page(params[:page]).reverse_order
    else
      @members = Member.exclude_member(current_member.id).search(params[:search]).page(params[:page]).reverse_order
    end
    
  end
  
end
