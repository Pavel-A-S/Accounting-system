class AddDateColumnToExchanges < ActiveRecord::Migration
  def change
    add_column :exchanges, :date, :datetime
  end
end
