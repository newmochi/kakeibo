class ModifyIncomes < ActiveRecord::Migration
  def change
    add_column :incomes, :iobject, :string

  end
end
