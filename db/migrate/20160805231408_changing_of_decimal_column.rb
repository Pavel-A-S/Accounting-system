class ChangingOfDecimalColumn < ActiveRecord::Migration
  def change
    change_column :quotations, :value, :decimal, precision: 10, scale: 4
  end
end
