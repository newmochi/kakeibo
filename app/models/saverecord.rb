class Saverecord < ActiveRecord::Base
  include CsvExportable
  belongs_to :saving
end
