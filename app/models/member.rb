class Member < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         
  attachment :image 
  
  #論理削除
  def active_for_authentication?
    super && (self.is_deleted == false )
  end  
  
  #性別選択
  enum sex: {
    man: 0,      #男性
    woman: 1,    #女性
    other: 2,    #その他
  }
end
