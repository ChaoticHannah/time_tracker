class ProjectMonthlyIncome < ActiveRecord::Base
	# associations
	belongs_to :project

	# attribute accessibility
	attr_accessible :project_id, :income_per_month, :month

	# validations
	validates :project_id, presence: true, inclusion: { in: Project.pluck(:id) }
	validates :income_per_month, presence: true, numericality: true, inclusion: { in: (0..50_000) }
	validates :month, presence: true

end
