class CreateUsers < ActiveRecord::Migration
  def up
    create_table :users do |t|
			t.string :name
			t.string :nickname
			t.string :password
			t.string :email
			t.string :role
			t.integer :salary_per_hour
			t.string :position

      t.timestamps
    end
  end

  def down
  	drop_table :users
  end
end
