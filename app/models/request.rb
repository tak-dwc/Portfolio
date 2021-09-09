class Request < ApplicationRecord
  belongs_to :member
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy

  #タグ機能
  has_many :request_tags, dependent: :destroy
  has_many :tags, through: :request_tags

  def save_tag(sent_tags)
    current_tags = self.tags.pluck(:name) unless self.tags.nil?
    old_tags = current_tags - sent_tags
    new_tags = sent_tags - current_tags

      old_tags.each do |old|
      self.tags.delete Tag.find_by(name: old)
      end

      new_tags.each do |new|
      new_request_tag = Tag.find_or_create_by(name: new)
      self.tags << new_request_tag
      end
  end  
  
  

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
