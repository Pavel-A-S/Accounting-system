class AddSentToToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :sent_to, :integer
  end
end
