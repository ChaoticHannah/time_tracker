class TasksController < ApplicationController
  before_filter :load_task, only: [:show, :edit, :update, :destroy, :change_status]


  def index
    @user = current_user
    @tasks = if params[:project_id]
      @project = Project.find params[:project_id]
      Project.find(params[:project_id]).tasks
    else
      Task.all.order('name ASC')
    end
  end

  def show
    @user = current_user
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new params[:task]
    if @task.save
      log_task @task, :created_task
      log_task @task, :assigned, " to #{@task.user.naming}" unless @task.user.nil?
      flash[:notice] = "Successfuly created"
      render :show
    else
      flash[:error] = "Error/s occured while creating"
      render :new
    end
  end

  def edit
  end

  def update
    prev_owner = @task.user
    @task.update_attributes params[:task]
    if @task.save
      new_owner = @task.user
      log_task @task, :updated_task
      log_task @task, :assigned, " to #{@task.user.naming}" if (prev_owner != new_owner)
      flash[:notice] = "Successfuly updated"
      render :show
    else
      flash[:error] = "Error/s occured while updating"
      render :edit
    end
  end

  def destroy
    name = @task.name
    @task.update_attribute :status, 'dismissed'
    log_task @task, :dismissed
    redirect_to tasks_path
  end

  def change_status
    case params[:status]
    when 'start'
      log_task @task, :started
      @task.update_attribute :started_at, DateTime.now
      @task.update_attribute :status, Task::IN_PROGRESS
    when 'finish'
      log_task @task, :done
      @task.update_attribute :real_time, (Time.now - @task.started_at.time.hour*3600 - @task.started_at.min*60)
      @task.update_attribute :deadline, @task.time_left
      @task.update_attribute :status, Task::DONE
    when 'dismiss'
      log_task @task, :stopped_progress
      @task.update_attribute :status, Task::CANCELLED
      @task.update_attribute :user_id, nil
      @task.update_attribute :real_time, nil
    when 'activate'
      log_task @task, :activated
      @task.update_attribute :status, Task::DEFAULT_STATUS
    when 'pause'
      @task.update_attribute :deadline, @task.time_left
      @task.update_attribute :real_time, (Time.now - @task.started_at.time.hour*3600 - @task.started_at.min*60)
      @task.update_attribute :status, Task::PAUSED
    when 'continue'
      @task.update_attribute :status, Task::IN_PROGRESS
    end
    redirect_to task_path @task
  end

  private
  def load_task
    @task = Task.find params[:id]
  end
end
