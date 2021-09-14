class Members::SearchesController < ApplicationController
  def search
      @model = params[:model]

      if @model == "Member"
        @members = Member.looks(params[:search])
      else
        @requests = Request.looks(params[:search])
      end
  end
end
