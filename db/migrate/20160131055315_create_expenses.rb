class CreateExpenses < ActiveRecord::Migration
  def change
    create_table :expenses do |t|
      t.date :exdate
      t.integer :exvalue
      t.integer :experson
      t.integer :exkindx
      t.integer :exkindy
      t.string :exfrom
      t.string :exnotice
      t.string :exdiary
      t.text :exdetail

      t.timestamps null: false
    end
  end
end
