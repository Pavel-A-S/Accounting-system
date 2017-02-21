class Exchange < ActiveRecord::Base
  before_save :to_utc
  has_many :records, foreign_key: :source_id, dependent: :destroy
  belongs_to :user
  has_many :exchange_files

  enum from_currency: ['from_RUR', 'from_USD', 'from_EUR', 'from_CHF']
  enum to_currency: ['to_RUR', 'to_USD', 'to_EUR', 'to_CHF']
  enum conversion_type: ['direct_conversion', 'reverse_conversion']

  validates :amount_before, numericality: { greater_than: 0,
                                            less_than: 90000000000 }
  validates :amount_after, numericality: { greater_than: 0,
                                           less_than: 90000000000 }
  validates :conversion_rate, numericality: { greater_than: 0,
                                              less_than: 90000000000 }

  def fill_journal
    records.create ccy: Exchange.from_currencies[from_currency],
                        description: description,
                        amount: -amount_before,
                        date: date + date.localtime.utc_offset,
                        record_type: :exchange
                                           

    records.create ccy: Exchange.to_currencies[to_currency],
                        description: description,
                        amount: amount_after,
                        date: date + date.localtime.utc_offset,
                        record_type: :exchange
  end

  def update_journal
    records.delete_all
    records.create ccy: Exchange.from_currencies[from_currency],
                        description: description,
                        amount: -amount_before,
                        date: date + date.localtime.utc_offset,
                        record_type: :exchange
                                           

    records.create ccy: Exchange.to_currencies[to_currency],
                        description: description,
                        amount: amount_after,
                        date: date + date.localtime.utc_offset,
                        record_type: :exchange

  end

  def to_utc
    self.date = self.date - self.date.localtime.utc_offset
  end
end
