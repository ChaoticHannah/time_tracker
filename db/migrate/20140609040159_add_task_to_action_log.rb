class AddTaskToActionLog < ActiveRecord::Migration
  def up
    add_column :action_logs, :task_id, :integer
  end

  def down
    remove_column :action_logs, :task_id
  end
end
