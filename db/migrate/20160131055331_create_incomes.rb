class CreateIncomes < ActiveRecord::Migration
  def change
    create_table :incomes do |t|
      t.date :idate
      t.integer :ivalue
      t.integer :iorgvalue
      t.integer :iperson
      t.integer :ikindx
      t.integer :ikindy
      t.string :ifrom
      t.string :inotice
      t.string :idiary
      t.text :idetail

      t.timestamps null: false
    end
  end
end
