class Admins::ContactsController < ApplicationController
  def index
    @contacts = Contact.page(params[:page]).order(created_at: :desc).per(10)
    @members = Member.all
  end
  
  def edit
    @contact = Contact.find(params[:id])
  end
  
  def update
    contact = Contact.find(params[:id])
    contact.update(contact_params)
    member = contact.member
    ContactMailer.send_when_admin_reply(member, contact).deliver_now #確認メールを送信
    redirect_to admins_contacts_path
    flash[:success] = '対応完了しました'
  end  
  
  private
  def contact_params
    params.require(:contact).permit(:title, :body, :reply)
  end
end
