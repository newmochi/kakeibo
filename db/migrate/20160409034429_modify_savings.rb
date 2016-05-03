class ModifySavings < ActiveRecord::Migration
  def change
    add_column :savings, :sobject, :string
  end
end
