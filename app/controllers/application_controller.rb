class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate_user!

  def log_project(project, action, text = nil)
    project.log_action(current_user, action, text.to_s)
  end

  def log_task(task, action, text = nil)
    task.log_action(current_user, action, text.to_s)
  end
end
