class AddRecordTypeToRecords < ActiveRecord::Migration
  def change
    add_column :records, :record_type, :integer
  end
end
