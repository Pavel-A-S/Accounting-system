class AddProjectIdCcyAmountSubjectToEvents < ActiveRecord::Migration
  def change
    add_column :events, :project_id, :string
    add_column :events, :ccy, :string
    add_column :events, :amount, :string
    add_column :events, :subject, :text
  end
end
