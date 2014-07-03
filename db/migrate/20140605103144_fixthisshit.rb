class Fixthisshit < ActiveRecord::Migration
  def change
     add_column :users, :active, :string
  end
end
