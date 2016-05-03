class Income < ActiveRecord::Base
  include CsvExportable
  validates :idate, presence: true
  validates :ivalue, presence: true, numericality: { only_integer: true }
  validates :ikindx, presence: true, numericality: { only_integer: true }
end
