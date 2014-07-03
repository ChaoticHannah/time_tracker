class DeleteTime < ActiveRecord::Migration
  def change
    remove_column :tasks, :estimate_time
  end
end
