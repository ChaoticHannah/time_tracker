class Admin::ActionLogsController < ApplicationController
  before_filter :authenticate_admin!
end
