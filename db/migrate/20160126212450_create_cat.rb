class CreateCat < ActiveRecord::Migration
  def change
    create_table :cats do |t|
      t.date :birth_date
      t.string :color
      t.string :name, null: false
      t.string :sex, limit: 1
      t.text :description

      t.timestamp
    end
  end
end
