class CreateExpenditures < ActiveRecord::Migration
  def change
    create_table :expenditures do |t|
      t.string :name
      t.text :description

      t.timestamps null: false
    end
  end
end
