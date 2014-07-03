class Task < ActiveRecord::Base

	# associations
	belongs_to :user
	belongs_to :project
  has_many :action_logs

	#attributes accessibility
	attr_accessible :name, :user_id, :project_id, :description, :real_time,
					        :status, :full_description, :specialization, :deadline

	TASK_STATUSES = [DEFAULT_STATUS =  "just created", CANCELLED = 'dismissed',
                   IN_PROGRESS = "in progress", DONE = "done",
                   PAUSED = 'paused']
  TASK_SPECIALIZATIONS = %w(content server_side script_writing UI_UX testing GA SEO)
	# validations
	validates :name, presence: true, uniqueness: true
	validates :project_id, presence: true, inclusion: { in: Project.pluck(:id) }
	validates :status, inclusion: { in: TASK_STATUSES }
  validates :description, presence: true, length: { maximum: 100 }
  validates :full_description, presence: true, length: { maximum: 800 }
  validates :specialization, presence: true, inclusion: { in: TASK_SPECIALIZATIONS }
  validates :deadline, presence: true

	after_initialize :set_default_state
  before_save :nil_if_blank

  scope :active, ->{ where status: TASK_STATUSES.except('dissmissed') }
  scope :dismissed, ->{ where status: 'dismissed' }
  scope :finished, ->{ where status: 'done' }
  scope :still_open, ->{ where status: [IN_PROGRESS, DEFAULT_STATUS, PAUSED] }
  scope :last_30_days, proc { |period| where created_at: (Time.now - 30.days)..Time.now }
  scope :started_this_month, -> { where created_at: Time.now.beginning_of_month..Time.now.end_of_month }
  scope :with_no_user, -> { where user_id: nil }
  scope :not_resolved, ->{ where('status = ? or status = ?', DEFAULT_STATUS, IN_PROGRESS) }

  [:just_created, :in_progress, :done, :dismissed, :paused].each do |in_status|
    define_method in_status do
      status == in_status.to_s.humanize.downcase
    end
  end


  def log_action(user, action, msg = '')
    action_logs.create! do |e|
      e.user = user
      e.project = project
      e.action = action
      e.data = msg
    end
  end

  def has_no_user
    !user
  end

  def time_left
    if started_at && status == IN_PROGRESS
      (started_at + 3*3600 + deadline.hour*3600 + deadline.min*60 - Time.now.hour*3600 - Time.now.min*60).time
     else
      deadline
    end
  end

	private
	def set_default_state
		self.status ||= DEFAULT_STATUS
	end

  def nil_if_blank
    [:user_id, :project_id].each { |attr| self[attr] = nil if self[attr].blank? }
  end
end
