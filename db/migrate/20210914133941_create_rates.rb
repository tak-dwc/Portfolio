class CreateRates < ActiveRecord::Migration[5.2]
  def change
    create_table :rates do |t|
      t.integer :member_id
      t.integer :request_id
      t.text    :rate_comment
      t.boolean :rate_choice, null: false, default: false

      t.timestamps
    end
  end
end
