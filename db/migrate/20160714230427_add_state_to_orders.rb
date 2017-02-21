class AddStateToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :state, :text
  end
end
