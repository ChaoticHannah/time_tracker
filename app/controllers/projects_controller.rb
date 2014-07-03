class ProjectsController < ApplicationController

  before_filter :load_collection
  before_filter :load_single, only: [:show, :edit, :destroy]

	def index
    @user = current_user
	end

  def new
    @project = Project.new
  end

  def create
    @project = Project.new params[:project]
    if @project.save
      log_project @project, :created
      flash[:notice] = "Project was saved"
      render :index
    else
      render :new
    end
  end

  def show
    @user = current_user
    @action_logs = ActionLog.for_project(@project).first(15)
    @incomes = @project.project_monthly_incomes.pluck(:income_per_month)
    @months_count = (1..@project.project_monthly_incomes.pluck(:month).count)
    @months = @project.project_monthly_incomes.pluck(:month).map! do |m|
      m.strftime("%b %Y")
    end
    @expenses = []
    12.times { @expenses.push rand(5_000...10_000) } unless  @incomes.empty?
    @profit = @incomes.each_with_index.collect {|val, index| val - @expenses[index]}
    @month_hash = Hash[@months_count.zip @months]
    @created = @project.tasks.last_30_days
    @still_open = @created.still_open ? @created.still_open.count : 0
    @finished = @created.finished ? @created.finished.count : 0
    @dismissed = @created.dismissed ? @created.dismissed.count : 0
  end

  def edit
    render :edit
  end

  def update
    @project = Project.find params[:id]
    @project.update_attributes params[:project]
    if @project.save
      log_project @project, :updated
      flash[:notice] = "Successfuly updated"
      render :show
    else
      render :edit
    end
  end

  def delete_logo
    @project = Project.find params [:id]
    log_project @project, :deleted_project_logo

    @project.logo.destroy
    redirect_to project_path(@project)
  end

  private
  def load_collection
    @projects = Project.all.order('name ASC')
  end

  def load_single
    @project = Project.find params[:id]
  end
end
