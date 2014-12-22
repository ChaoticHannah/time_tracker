class UsersController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_user, except: [:index]


	def index
		@users = User.active.order('last_sign_in_at DESC')
    @user = current_user
	end

	def show
    @action_logs = ActionLog.for_user(@user).first(15)
	end

	def edit
	end

  def update
    params[:user].delete(:password) if params[:user][:password].blank?
    @user.update_attributes params[:user]
    if @user.save
      redirect_to user_path(@user), notice: "Successfuly updated"
    else
      render :edit
    end
  end

  def block
    @user.update_attribute :active, User::BLOCKED
    respond_to do |format|
      format.html { redirect_to users_path }
      format.js   { render nothing: true }
    end
  end

  def unblock
    @user.update_attribute :active, User::ACTIVE
    respond_to do |format|
      format.html { redirect_to blocked_users_path }
      format.js   { render nothing: true }
    end
  end

  def blocked
    @users = User.blocked.order('last_sign_in_at DESC')
  end

  def list_tasks
    if params.include?(:project_id)
      @tasks =  @user.tasks.where(project_id: params[:project_id])
      @project = Project.find params[:project_id]
    else
      @tasks = @user.tasks
    end
  end

  def show_statistics
    @tasks = @user.tasks.started_this_month
    @projects = Project.where(id: @tasks.pluck(:project_id))
    dismissed = ActionLog.where(user_id: @user.id, action: :stopped_progress)
    @dismissed = dismissed ? dismissed.count : 0
  end

  def delete_avatar
    @user.avatar.destroy
    redirect_to user_path @user
  end

  private

  def find_user
    @user = User.find(params[:id])
  end

end
