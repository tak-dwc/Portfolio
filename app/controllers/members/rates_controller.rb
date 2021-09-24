class Members::RatesController < ApplicationController
  def new
    @rate = Rate.new
  end

  def create
    @rate = Rate.new(rate_params)
  end

  private

  def rate_params
    params.require(:rate).permit(:member_id, :request_id, :rated_id, :rate_comment, :rate_choice)
  end
end
