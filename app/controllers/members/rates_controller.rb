class Members::RatesController < ApplicationController
  
  def create
    @rate = Rate.new
  end
  
  
  def new
    @rate = Rate.new
    
  end
end
