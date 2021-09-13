class CreateChats < ActiveRecord::Migration[5.2]
  def change
    create_table :chats do |t|
      t.integer :member_id, null: false
      t.integer :room_id, null: false
      t.text :body, null: false

      t.timestamps
    end
  end
end
