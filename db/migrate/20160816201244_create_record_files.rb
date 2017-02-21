class CreateRecordFiles < ActiveRecord::Migration
  def change
    create_table :record_files do |t|
      t.string :path
      t.references :record, index: true, foreign_key: true
      t.string :name

      t.timestamps null: false
    end
  end
end
