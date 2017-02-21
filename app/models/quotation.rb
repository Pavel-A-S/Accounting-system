class Quotation < ActiveRecord::Base
  enum code: ['USD', 'EUR', 'CHF']

  def self.update_quotation_value(code, value)
    if codes[code] && !value.blank?
      new_quotation = find_by(code: codes[code])
      if new_quotation
        new_quotation.value = value.gsub(',', '.')
        new_quotation.save
      else
        create code: code, value: value.gsub(',', '.')
      end
    end
  end

end
