class Members::RatesController < ApplicationController
  def new
    @request = Request.find(params[:request_id])
    @rate = Rate.new
    @request_room_data = @request.room.entries.where.not(member_id: current_member.id)
    @member = Member.find(@request_room_data.first.member_id)
 
  end

  def create
    @rate = Rate.new(rate_params)
    if @rate.save
      if @rate.request.rates.count == 2
        @rate.request.update(is_active: "end_transaction")
      end
      redirect_to room_path(@rate.request.room)
      flash[:success] = "評価完了しました!"
    else
      render :new
      flash[:error] = "送信に失敗しました。"
    end
  end

  def index
    member = Member.find(params[:member_id])
    self_request_id = member.rates.pluck(:request_id)
    other_request_rates = Rate.where.not(member_id: member.id).where(request_id: self_request_id)
    
    # good評価
    @passive_rates_good = other_request_rates.where(rate_choice: false)
    @good_rates = @passive_rates_good.page(params[:page]).per(6)
    # bad評価
    @passive_rates_bad = other_request_rates.where(rate_choice: true)
    @bad_rates = @passive_rates_bad.page(params[:page]).per(6)
      # rates = @member.rates
      # request_arr = rates.map{|x| x.request}  # mapは
      # res = request_arr.map{|x|
      #   x.rates.map{
      #     |y| y.member_id != @member.id ? y : nil
      #   }
      # }
      # @passive_rates = res.flatten.compact
      # @false_count = 0
      # @true_count = 0
      # @self_request_id.each do |rate|
      #   if rate["rate_choice"] == false
      #     @false_count = @false_count + 1
      #   else
      #     @true_count = @true_count + 1
      #   end
      # end
  end

  private

  def rate_params
    params.require(:rate).permit(:rate_comment, :rate_choice).merge(request_id: params[:request_id], member_id: current_member.id)
  end
end
