class Members::MembersController < ApplicationController

  def show
    @member = Member.find(params[:id])
  end  
  
  def edit
    @member = Member.find(params[:id])
  end
  
  def update
    @member = Member.find(params[:id])
    @member.update(member_params)
    redirect_to member_path(@member)
  end  
  
  def unsubscribe
  end
  
  def withdraw
    @member = Member.find(params[:id])
    @member.update(is_deleted: true)
    reset_session
    redirect_to root_path
  end  
  
  private

  def member_params
    params.require(:member).permit(:last_name,:first_name,:last_name_kana,:first_name_kana,:nickname,:sex,:image,:hobby,:job,:introduction,:email)
  end

  
  
end
