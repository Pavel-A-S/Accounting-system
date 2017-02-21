class AddProjectIdToIncomes < ActiveRecord::Migration
  def change
    add_column :incomes, :project_id, :integer
  end
end
