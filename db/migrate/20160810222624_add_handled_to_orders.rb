class AddHandledToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :handled, :boolean
  end
end
