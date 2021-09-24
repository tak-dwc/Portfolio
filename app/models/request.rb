# frozen_string_literal: true

class Request < ApplicationRecord
  belongs_to :member
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy

  # タグ機能
  has_many :request_tags, dependent: :destroy
  has_many :tags, through: :request_tags

  # 通知機能
  has_many :notifications, dependent: :destroy

  # 評価機能
  has_many :rates, dependent: :destroy

  validates :title, presence: true
  validates :content, presence: true
  validates :location, presence: true
  validates :schedule, presence: true

  # タグ作成・更新
  # DBへのコミット直前に実施する
  after_create do
    request = Request.find_by(id: id)
    tags = caption.scan(/[#＃][\w\p{Han}ぁ-ヶｦ-ﾟー]+/)
    request.tags = []
    tags.uniq.map do |tag|
      # ハッシュタグは先頭の'#'を外した上で保存
      tag = Tag.find_or_create_by(name: tag.downcase.delete('#'))
      request.tags << tag
    end
  end

  before_update do
    request = Request.find_by(id: id)
    request.tags.clear
    tags = caption.scan(/[#＃][\w\p{Han}ぁ-ヶｦ-ﾟー]+/)
    tags.uniq.map do |tag|
      tag = Tag.find_or_create_by(name: tag.downcase.delete('#'))
      request.tags << tag
    end
  end

  # いいね
  # likesテーブルのmember_idにmember.idがすでに存在しているかの確認
  def liked_by?(member)
    likes.where(member_id: member.id).exists?
  end

  # 検索
  def self.looks(search)
    return Request.all unless search
    Request.where('title LIKE(?) OR location LIKE(?) OR content LIKE(?)', "%#{search}%", "%#{search}%", "%#{search}%")
  end

  # 通知：いいね
  def create_notification_like!(current_member)
    # すでに通知があるか。順番に必要情報を記載
    temp = Notification.where([" visitor_id = ? and visited_id = ? and request_id = ? and action =? ", current_member.id, member_id, id, "like"])
    # blank?でtempがない場合のみ新規作成
    if temp.blank?
      # visitor_idはcurrent_member.idのため記載なし
      notification = current_member.go_notifications.new(visited_id: member_id, request_id: id, action: "like")
      notification.save if notification.valid?
    end
  end

  # 通知：コメント
  def create_notification_comment!(current_member, comment_id)
    # 1.投稿にコメントしているmemre_idのリスト取得 2.where.notでcurrent_member.id以外を指定 3.distinct=重複レコードをまとめる
    temp_ids = Comment.select(:member_id).where(request_id: id).where.not(member_id: current_member.id).distinct
    temp_ids.each do |temp_id|
      save_notification_comment!(current_member, comment_id, temp_id["member_id"])
    end
    # 誰もコメントしていない場合は、投稿者に通知を送る
    save_notification_comment!(current_member, comment_id, member_id) if temp_ids.blank?
  end

  def save_notification_comment!(current_member, comment_id, visited_id)
    # コメントは複数回することが考えられるため
    notification = current_member.go_notifications.new(visited_id: visited_id, request_id: id, comment_id: comment_id, action: "comment")
    notification.save if notification.valid?
  end

  # リクエスト状態選択
  enum is_active: {
    release: 0,           # 公開中
    in_transaction: 1,    # 取引中-作業中
    end_transaction: 2,   # 依頼終了
    release_stop: 9,      # 公開停止
  }
end
