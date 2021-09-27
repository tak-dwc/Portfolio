class Members::RatesController < ApplicationController
  def new
    @request = Request.find(params[:request_id])
    @rate = Rate.new
    @member = @request.room.entries.where.not(member_id: current_member.id).select(:member_id)

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

  def index
    @member = Member.find(params[:member_id])
      rates = @member.rates
      request_arr = rates.map{|x| x.request}  # mapは
      res = request_arr.map{|x|
        x.rates.map{
          |y| y.member_id != @member.id ? y : nil
        }
      }
      @passive_rates = res.flatten.compact
      
      @false_count = 0
      @true_count = 0
      @passive_rates.each do |rate|
        if rate["rate_choice"] == false
          @false_count = @false_count + 1
        else
          @true_count = @true_count + 1
        end
      end
  end

  private

  def rate_params
    params.require(:rate).permit(:rate_comment, :rate_choice).merge(request_id: params[:request_id], member_id: current_member.id)
  end
end
