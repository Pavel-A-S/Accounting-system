class ChangeAmountColumnTypeToDecimalInRecords < ActiveRecord::Migration
  def change
    change_column :records, :amount, :decimal, precision: 13, scale: 4
  end
end
