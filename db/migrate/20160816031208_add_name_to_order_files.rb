class AddNameToOrderFiles < ActiveRecord::Migration
  def change
    add_column :order_files, :name, :string
  end
end
