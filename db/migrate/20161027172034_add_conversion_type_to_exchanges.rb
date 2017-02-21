class AddConversionTypeToExchanges < ActiveRecord::Migration
  def change
    add_column :exchanges, :conversion_type, :integer
  end
end
