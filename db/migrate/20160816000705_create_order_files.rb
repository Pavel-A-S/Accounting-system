class CreateOrderFiles < ActiveRecord::Migration
  def change
    create_table :order_files do |t|
      t.string :path
      t.references :order, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
