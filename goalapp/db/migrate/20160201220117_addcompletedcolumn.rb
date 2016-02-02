class Addcompletedcolumn < ActiveRecord::Migration
  def change
    add_column :goals, :completed, :boolean
    change_column :goals, :completed, :boolean, null: false
    end
end
