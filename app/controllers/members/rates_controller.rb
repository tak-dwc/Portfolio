class Members::RatesController < ApplicationController
  def new
    @request = Request.find(params[:request_id])
    @rate = Rate.new
  end

  def create
    @rate = Rate.new(rate_params)
    # return if @rate.request.rates.find_by(member_id: current_user.id).present?
    if @rate.save
      if @rate.request.rates.count == 2
        @rate.request.update(is_active: "end_transaction")
      end
      redirect_to room_path(@rate.request.room)
      flash[:success] = "評価完了しました!"
    else
      render :new
      flash[:error] = "失敗しました"
    end
  end

  private

  def rate_params
    params.require(:rate).permit(:rate_comment, :rate_choice).merge(request_id: params[:request_id], member_id: current_member.id)
  end
end
