# frozen_string_literal: true

class Comment < ApplicationRecord
  belongs_to :member
  belongs_to :request
  
  #通知機能
  has_many :notifications, dependent: :destroy

  validates :comment, presence: true
end
