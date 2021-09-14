# frozen_string_literal: true

class Request < ApplicationRecord
  belongs_to :member
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy

  # タグ機能
  has_many :request_tags, dependent: :destroy
  has_many :tags, through: :request_tags

  #DBへのコミット直前に実施する
  after_create do
    request = Request.find_by(id: self.id)
    tags  = self.caption.scan(/[#＃][\w\p{Han}ぁ-ヶｦ-ﾟー]+/)
    request.tags = []
    tags.uniq.map do |tag|
      #ハッシュタグは先頭の'#'を外した上で保存
      tag = Tag.find_or_create_by(name: tag.downcase.delete('#'))
      request.tags << tag
    end
  end

  before_update do
    request = Request.find_by(id: self.id)
    request.tags.clear
    tags = self.caption.scan(/[#＃][\w\p{Han}ぁ-ヶｦ-ﾟー]+/)
    tags.uniq.map do |tag|
      tag = Tag.find_or_create_by(name: tag.downcase.delete('#'))
      request.tags << tag
    end
  end

  # likesテーブルのmember_idにmember.idがすでに存在しているかの確認
  def liked_by?(member)
    likes.where(member_id: member.id).exists?
  end
 
  # 検索
  def self.looks(search)
    return Request.all unless search
    Request.where('title LIKE(?) OR location LIKE(?) OR content LIKE(?)', "%#{search}%","%#{search}%","%#{search}%")
  end
 
 
  # リクエスト状態選択
  enum is_active: {
    release: 0,           # 公開中
    in_transaction: 1,    # 取引中-作業中
    end_transaction: 2,   # 依頼終了
    release_stop: 9      # 公開停止
  }

end
