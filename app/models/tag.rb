# frozen_string_literal: true

class Tag < ApplicationRecord
  has_many :request_tags, dependent: :destroy
  has_many :requests, through: :request_tags

  validates :name, uniqueness: true
end
