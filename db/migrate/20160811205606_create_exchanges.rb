class CreateExchanges < ActiveRecord::Migration
  def change
    create_table :exchanges do |t|
      t.integer :from_currency
      t.integer :to_currency
      t.decimal :amount_before, precision: 14, scale: 2
      t.decimal :amount_after, precision: 14, scale: 2
      t.decimal :conversion_rate, precision: 14, scale: 4
      t.text :description

      t.timestamps null: false
    end
  end
end
