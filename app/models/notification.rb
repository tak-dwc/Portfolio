class Notification < ApplicationRecord
  #常に新しい順でデータを取得させる
  default_scope -> { order(created_at: :desc) }
  #optional: trueでnilの許可.belongs_toはnilが許可されていない為
  belongs_to :request, optional: true
  belongs_to :comment, optional: true
  
  belongs_to :visitor, class_name: "Member", foreign_key: "visitor_id" 
  belongs_to :visited, class_name: "Member", foreign_key: "visited_id"
end
