class CreateRates < ActiveRecord::Migration[5.2]
  def change
    create_table :rates do |t|
      t.integer :member_id, null: false
      t.integer :request_id, null: false
      t.integer :reted_id, null: false
      t.text    :rate_comment
      t.boolean :rate_choice, null: false, default: false
      t.float   :rate_star, null: false

      t.timestamps
    end
  end
end
