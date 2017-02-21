class CreateRights < ActiveRecord::Migration
  def change
    create_table :rights do |t|
      t.integer :order_id
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
