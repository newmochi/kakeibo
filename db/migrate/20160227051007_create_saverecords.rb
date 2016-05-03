class CreateSaverecords < ActiveRecord::Migration
  def change
    create_table :saverecords do |t|
      t.references :saving, index: true
      t.date :srnowdate
      t.integer :srnowvalue
      t.string :srnownotice
      t.string :srnowdiary
      t.text :srnowdetail
      t.date :srnextdate

      t.timestamps null: false
    end
    add_foreign_key :saverecords, :savings
  end
end
