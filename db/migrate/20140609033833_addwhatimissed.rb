class Addwhatimissed < ActiveRecord::Migration
  def up
    add_column :tasks, :deadline, :time
    add_column :tasks, :priority, :string
  end

  def down
    remove_column :tasks, :deadline
    remove_column :tasks, :priority
  end
end
