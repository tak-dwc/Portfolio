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
  
  #フォロー機能
  #フォローしている人
  has_many :relationships, class_name: "Relationship", foreign_key: "follower_id",dependent: :destroy
  has_many :followings,through: :relationships, source: :followed
  
  #フォローされている人
  has_many :re_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :followers, through: :re_relationships, source: :follower
  
  def follow(member_id)
    relationships.create(followed_id: member_id)
  end
  
  def unfollow(member_id)
    relationships.find_by(followed_id: member_id).destroy
  end
  
  def following?(member)
    followings.include?(member)
  end  
end
