class OrderFile < ActiveRecord::Base
  before_destroy :delete_file
  belongs_to :order

  def delete_file
    FileUtils.rm_f "#{Rails.root}#{path}"
    return unless Dir["#{Rails.root}#{path[%r{\A.*/}]}*"].empty?
    FileUtils.rmdir "#{Rails.root}#{path[%r{\A.*/}]}"
  end
end
