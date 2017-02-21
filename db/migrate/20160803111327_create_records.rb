class CreateRecords < ActiveRecord::Migration
  def change
    create_table :records do |t|
      t.integer :source_id
      t.datetime :date
      t.integer :ccy
      t.integer :amount
      t.text :description

      t.timestamps null: false
    end
  end
end
