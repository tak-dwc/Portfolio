class Comment < ApplicationRecord
  belongs_to :member
  belongs_to :request

  validates :comment, presence: true
end
