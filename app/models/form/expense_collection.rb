class Form::ExpenseCollection < Form::Base
  DEFAULT_ITEM_COUNT = 10
  attr_accessor :expenses

  def initialize(attributes = {})
    super attributes
    self.expenses = DEFAULT_ITEM_COUNT.times.map { Form::Expense.new } unless expenses.present?
  end

  def expenses_attributes=(attributes)
    self.expenses = attributes.map do |_, expense_attributes|
#      Form::Expense.new(expense_attributes).tap { |v| v.availability = false }
      Form::Expense.new(expense_attributes)
    end
  end

  def valid?
    valid_expenses = target_expenses.map(&:valid?).all?
    super && valid_expenses
  end

  def save
    return false unless valid?
    Expense.transaction { target_expenses.each(&:save!) }
    true
  end

  def target_expenses
#    self.expenses.select { |v| value_to_boolean(v.register) }
    self.expenses.select { |v| v.register = 'false' }
    self.expenses.select { |v| v.register = 'true' unless v.exdate.blank? }
  end
end
