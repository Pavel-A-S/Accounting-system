class AddExpenditureIdToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :expenditure_id, :integer
  end
end
