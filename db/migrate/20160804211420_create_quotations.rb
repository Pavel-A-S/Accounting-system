class CreateQuotations < ActiveRecord::Migration
  def change
    create_table :quotations do |t|
      t.integer :code
      t.decimal :value

      t.timestamps null: false
    end
  end
end
