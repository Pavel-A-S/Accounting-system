class ConvertTextToInteger < ActiveRecord::Migration
  def change
    change_column :orders, :state, :integer
  end
end
