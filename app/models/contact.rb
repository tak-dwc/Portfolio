class Contact < ApplicationRecord
  belongs_to :member
  
  validates :title, presence: true
  validates :body, presence: true
  validates :reply, presence: true  
end
