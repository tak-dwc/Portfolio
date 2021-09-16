class Members::ContactsController < ApplicationController
  def new
    @contact = Contact.new
  end
  
  def create
    @contact = Contact.new(contact_params)
    @contact.member_id = current_member.id
    if @contact.save
      flash[:success] = 'お問い合わせを送信しました。'
      redirect_to member_path(current_member)
    else
      render :new
    end
  end  
  
  private 
  def contact_params
    params.require(:contact).permit(:member_id,:title,:body,:reply)
  end  
end
