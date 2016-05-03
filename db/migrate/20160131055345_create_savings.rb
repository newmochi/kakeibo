class CreateSavings < ActiveRecord::Migration
  def change
    create_table :savings do |t|
      t.date :scheckdate
      t.integer :svalue
      t.integer :sperson
      t.integer :skindx
      t.integer :skindy
      t.string :sfrom
      t.string :snotice
      t.string :sdiary
      t.text :sdetail

      t.timestamps null: false
    end
  end
end
