class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :phone_number
      t.datetime :tested_at
      t.boolean :infected
      t.integer :user_id

      t.timestamps
    end
  end
end
