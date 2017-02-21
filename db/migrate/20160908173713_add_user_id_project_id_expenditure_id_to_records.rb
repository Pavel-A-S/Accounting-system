class AddUserIdProjectIdExpenditureIdToRecords < ActiveRecord::Migration
  def change
    add_column :records, :user_id, :integer
    add_column :records, :project_id, :integer
    add_column :records, :expenditure_id, :integer
  end
end
