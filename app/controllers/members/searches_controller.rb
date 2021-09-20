class Members::SearchesController < ApplicationController
  def search
      @model = params[:model]

      if @model == "Request"
        @requests = Request.looks(params[:search]).page(params[:page]).reverse_order
      else
        @members = Member.looks(params[:search]).page(params[:page]).reverse_order
      end
  end
end
