class ChangePrecisionAndScaleForAmountColumnInRecords < ActiveRecord::Migration
  def change
    change_column :records, :amount, :decimal, precision: 14, scale: 2
  end
end
