# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)
require 'rake'

Reviewer::Application.load_tasks
task :test => :spec

task :send_notifications => :environment do

	Notification.unread.grouped_by_user.each do |notification|
		NotificationMailer.send_unread_notifications(notification.user).deliver
	end

end