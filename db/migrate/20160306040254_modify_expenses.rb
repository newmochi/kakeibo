class ModifyExpenses < ActiveRecord::Migration
  def change
    add_column :expenses, :exextrasoutou, :integer
    add_column :expenses, :execosoutou, :integer
    add_column :expenses, :exobject, :string
  end
end
