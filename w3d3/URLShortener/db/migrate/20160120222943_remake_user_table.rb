class RemakeUserTable < ActiveRecord::Migration
  def change
    drop_table :users

    create_table :users do |t|
      t.string :email

      t.timestamps
    end

    add_index :users, :email

  end
end
