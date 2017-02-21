class AddUserIdToExchanges < ActiveRecord::Migration
  def change
    add_column :exchanges, :user_id, :integer
  end
end
