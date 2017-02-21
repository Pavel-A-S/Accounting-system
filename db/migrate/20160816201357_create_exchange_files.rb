class CreateExchangeFiles < ActiveRecord::Migration
  def change
    create_table :exchange_files do |t|
      t.string :path
      t.references :exchange, index: true, foreign_key: true
      t.string :name

      t.timestamps null: false
    end
  end
end
