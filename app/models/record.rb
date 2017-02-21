class Record < ActiveRecord::Base
  before_save :to_utc
  belongs_to :expenditure, foreign_key: :source_id, class_name: 'Order'
  belongs_to :income, foreign_key: :source_id
  belongs_to :exchange, foreign_key: :source_id
  belongs_to :project
  belongs_to :expenditure_type, foreign_key: :expenditure_id,
                                class_name: 'Expenditure'
  belongs_to :user
  has_many :record_files

  enum record_type: [:income, :expenditure, :exchange]
  enum ccy: ['RUR', 'USD', 'EUR', 'CHF']

  validates :amount, numericality: { greater_than: -90000000000,
                                     less_than: 90000000000 }
  def to_utc
    self.date = self.date - self.date.localtime.utc_offset
  end
end
