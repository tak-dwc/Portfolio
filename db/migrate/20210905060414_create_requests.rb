class CreateRequests < ActiveRecord::Migration[5.2]
  def change
    create_table :requests do |t|
      t.integer :member_id ,:null =>false
      t.date :schedule ,:null =>false
      t.text :content ,:null =>false
      t.string :location ,:null =>false
      t.integer :is_active ,:null =>false ,:default => 0
      t.string :title,:null =>false

      t.timestamps
    end
  end
end
