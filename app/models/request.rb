class Request < ApplicationRecord
  belongs_to :member
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy


  #likesテーブルのmember_idにmember.idがすでに存在しているかの確認
  def liked_by?(member)
    likes.where(member_id: member.id).exists?
  end

   #リクエスト状態選択
  enum is_active: {
    release: 0,           #公開中
    in_transaction: 1,    #取引中-作業中
    end_transaction: 2,   #依頼終了
    release_stop: 9,      #公開停止
  }
end
