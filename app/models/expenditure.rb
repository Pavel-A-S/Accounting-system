class Expenditure < ActiveRecord::Base
  has_many :orders
  validates :name, presence: true
  #  validates :description, presence: true
end
