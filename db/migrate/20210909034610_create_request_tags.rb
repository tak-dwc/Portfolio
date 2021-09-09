class CreateRequestTags < ActiveRecord::Migration[5.2]
  def change
    create_table :request_tags do |t|
      t.integer :request_id, :null =>false
      t.integer :tag_id, :null =>false

      t.timestamps
    end
  end
end
