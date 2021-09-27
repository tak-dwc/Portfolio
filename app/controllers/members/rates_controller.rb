class Members::RatesController < ApplicationController
  def new
    @request = Request.find(params[:request_id])
    @rate = Rate.new
    #binding.pry
    @request_room_data = @request.room.entries.where.not(member_id: current_member.id)
    @member = Member.find(@request_room_data.first.member_id)
    #binding.pry

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
      # rates = @member.rates
      # request_arr = rates.map{|x| x.request}  # mapは
      # res = request_arr.map{|x|
      #   x.rates.map{
      #     |y| y.member_id != @member.id ? y : nil
      #   }
      # }
      # @passive_rates = res.flatten.compact

      # binding.irb
      self_request_id = member.rates.pluck(:request_id)
      self_request_rates = Rate.where.not(member_id: member.id).where(request_id: self_request_id)
      # @passive_rates_good_count = self_request_rates.where(rate_choice: false).count
      # @passive_rates_bad_count = self_request_rates.where(rate_choice: true).count
      @passive_rates_good = self_request_rates.where(rate_choice: false)
      @passive_rates_bad = self_request_rates.where(rate_choice: true)
      @good_page = @passive_rates_good.page(params[:page]).per(6)
      # binding.irb

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
