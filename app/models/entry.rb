class Entry < ApplicationRecord
  belongs_to :member
  belongs_to :room
  # has_many :requests, through: :member
end
