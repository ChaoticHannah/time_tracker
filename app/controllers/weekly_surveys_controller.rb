class WeeklySurveysController < ApplicationController

	def index
	end

	def new
		@survey = WeeklySurvey.new
	end

	def create
	end

end
