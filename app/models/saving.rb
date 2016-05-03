class Saving < ActiveRecord::Base
  validates :scheckdate, presence: true
  validates :svalue, presence: true, numericality: { only_integer: true }
  validates :skindx, presence: true, numericality: { only_integer: true }
  has_many :saverecords, dependent: :destroy
end
