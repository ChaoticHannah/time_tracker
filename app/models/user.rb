class User < ActiveRecord::Base
	include ActiveModel::Validations

  # default devise modules
  devise :database_authenticatable, :registerable,
         :trackable, :validatable
	# associations
  has_many :projects, through: :tasks
	has_many :tasks, dependent: :delete_all
  has_many :action_logs, dependent: :delete_all

	# attribute accessibility
	attr_accessible :name, :nickname, :email, :role, :position, :salary_per_hour,
					:level, :weekly_surveys_attributes, :password, :active, :avatar

  has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100>", :small => "40x40>" }, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

	accepts_nested_attributes_for :tasks

	# constants
  USER_ACTIVE_STATUSES = [ACTIVE = "active", BLOCKED = "blocked"]
	USER_ROLES = [DEFAULT_ROLE = 'user', MANAGER = 'manager', ADMIN = 'admin']
	USER_WORK_LEVELS = %w(junior middle senior)
	USER_SPECIALIZATIONS = ['tester', 'back-end developer', 'front-end developer', 'SEO', 'content manager']
  ATTRIBUTES_TO_SCRUB = %w(id created_at updated_at encrypted_password sign_in_count
                          current_sign_in_at last_sign_in_at current_sign_in_ip last_sign_in_ip
                          password avatar_file_name avatar_content_type avatar_file_size
                          avatar_updated_at)

	# validations
	validates :name, presence:true, uniqueness: true, length: { maximum: 100 }, on: :update
  validates :email, presence: true, uniqueness: true
  validates :role, presence: true, inclusion: { in: USER_ROLES }, on: :update
  validates :salary_per_hour, presence: true, numericality: true, inclusion: { in: (1..100) }, on: :update
  validates :level, presence: true, inclusion: { in: USER_WORK_LEVELS }, on: :update
  validates :position, presence: true, inclusion: { in: USER_SPECIALIZATIONS }, on: :update

  before_save :set_default_settings
  after_initialize :set_active, on: :create

  scope :active, -> { where(:active => ACTIVE) }
  scope :blocked, -> { where(:active => BLOCKED) }

  def admin?
  	role == ADMIN
  end

  def manager?
  	role == MANAGER
  end

  def active?
    active == ACTIVE
  end

  def new_tasks
    tasks ? tasks.where('status = ?', Task::DEFAULT_STATUS) : []
  end

  def new_tasks_counter
    tasks ? new_tasks.count : 0
  end

  #def projects
    #ids = Task.where('user_id = ? ', id).pluck(:project_id)
    #Project.find(ids)
  #end

  def naming
    name || nickname
  end

  def started_this_month_tasks
    tasks.started_this_month
  end

  def general_month_time
    started_this_month_tasks.finished.pluck(:real_time).inject do |total_time, time|
      total_time + time.hour*3600 + time.min*60
    end
  end

  def calculate_salary
    if salary_per_hour
      salary_per_minute = salary_per_hour.to_f/60
      general_month_time.hour*salary_per_hour + general_month_time.min*salary_per_minute
    end
  end

  private
  def set_default_settings
  	self.role ||= DEFAULT_ROLE
  	self.nickname ||= email.split('@')[0]
  end

  def set_active
    self.active ||= ACTIVE
  end
end
