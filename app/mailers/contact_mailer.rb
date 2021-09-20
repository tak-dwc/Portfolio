class ContactMailer < ApplicationMailer
  
  default from: 'from@example.com'

  def send_when_admin_reply(member, contact) #メソッドに対して引数を設定
    @member = member #ユーザー情報
    @answer = contact.reply #返信内容
    mail to: member.email, subject: '【Sharehobby カスタマーセンター】 お問い合わせありがとうございます'
  end
end
