class ActionLog < ActiveRecord::Base
  ACTIONS = %i(started created done assigned deleted deleted_project_logo updated commented)

  belongs_to :user
  belongs_to :project
  belongs_to :task

  attr_accessible :user, :user_username, :user_name, :project, :project_name,
                  :action, :data, :task, :task_name

  default_scope { order('created_at DESC') }

  scope :for_project, proc { |project| where(project_id: project.id) }
  scope :for_user, proc { |user| where(user_id: user.id) }
  scope :for_task, proc { |task| where(task_id: task.id) }
end
