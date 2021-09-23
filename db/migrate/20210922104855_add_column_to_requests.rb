class AddColumnToRequests < ActiveRecord::Migration[5.2]
  def change
    add_column :requests, :room_id, :integer
  end
end
