class Expense < ActiveRecord::Base
  include CsvExportable
  validates :exdate, presence: true
  validates :exvalue, presence: true, numericality: { only_integer: true }
  validates :exextrasoutou, presence: true, numericality: { only_integer: true }
  validates :execosoutou, presence: true, numericality: { only_integer: true }
  validates :experson, presence: true, numericality: { only_integer: true }
#  validates :exkindx, presence: true, inclusion: { in: (1..10) }
  validate :check_exkindx

  private
  def check_exkindx
    case
      when exkindx.between?(0, 9)
        errors.add(:exkindx, :invalid) unless
        exkindx.between?(0, 9)
      when exkindx.between?(10, 19)
        errors.add(:exkindx, :invalid) unless
        exkindx.between?(10, 19)
      when exkindx.between?(20, 29)
        errors.add(:exkindx, :invalid) unless
        exkindx.between?(20, 29)
      when exkindx.between?(30, 39)
        errors.add(:exkindx, :invalid) unless
        exkindx.between?(30, 39)
      when exkindx.between?(40, 49)
        errors.add(:exkindx, :invalid) unless
        exkindx.between?(40, 49)
      when exkindx.between?(50, 59)
        errors.add(:exkindx, :invalid) unless
        exkindx.between?(50, 59)
      when exkindx.between?(60, 69)
        errors.add(:exkindx, :invalid) unless
        exkindx.between?(60, 69)
      when exkindx.between?(70, 79)
        errors.add(:exkindx, :invalid) unless
        exkindx.between?(70, 79)
      when exkindx.between?(80, 89)
        errors.add(:exkindx, :invalid) unless
        exkindx.between?(80, 89)
      when exkindx.between?(90, 99)
        errors.add(:exkindx, :invalid) unless
        exkindx.between?(90, 99)
    end
  end
end
