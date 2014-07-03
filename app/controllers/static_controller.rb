class StaticController < ApplicationController

  require 'matrix'
  require 'hungerian'
  before_filter :authenticate_user!

  DAYTIMES =  { morning: (4...12), afternoon: (12...18), evening: (18...22), night: (22..4) }

  def blocked
    @user = current_user
  end

  def dashboard
    @user = current_user
    if @user.active?
      @action_logs = ActionLog.order('created_at DESC').first(15)
      DAYTIMES.each do |key, value|
        @daytime = key.to_s if value.include?(Time.now.hour)
      end
    else
      render :blocked
    end
  end

  def task_adviser
    @user = current_user
    @tasks = Task.with_no_user
    @users ||= []
    @solution ||= []
    4.times { |i| @users.push(params[:assigned_users][:"#{i}"]) if params[:assigned_users][:"#{i}"] } if params[:assigned_users]
    @skills = if params[:randomize]
      Matrix.build(4, 4) {|row, col| rand(1..40)}
    else
      Matrix.build(4, 4) {|row, col| params[:"skill-#{row}-#{col}"].to_i}
    end
    if (@skills.to_a.flatten.uniq.inject {|sum, val| sum+val} != 0) && params[:commit] =='advise'
      hungarian = Hungarian.new(@skills.to_a)
      @solution  = hungarian.solve
    end
  end
end
