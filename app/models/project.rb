class Project < ActiveRecord::Base
  require 'uri'
	# assosiations
	has_many :tasks, dependent: :delete_all
  has_many :users, through: :tasks
  has_many :action_logs, dependent: :delete_all
  has_many :project_monthly_incomes

	#attributes accessibility
	attr_accessible :name, :user_id, :description, :site, :logo

  has_attached_file :logo, :styles => { medium: "300x300>", thumb: "100x100>", small: "40x40>" }
  validates_attachment_content_type :logo, :content_type => /\Aimage\/.*\Z/

	validates :name, presence: true, uniqueness: true
  validates :site, format: {with: URI.regexp(%w(http https))}

  def log_action(user, action, msg = '')
    action_logs.create! do |e|
      e.user = user
      e.action = action
      e.data = msg
    end
  end

end
