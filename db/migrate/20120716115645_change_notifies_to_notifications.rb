class ChangeNotifiesToNotifications < ActiveRecord::Migration
  def self.up
  	rename_table :notifies, :notifications
  end

  def self.down
  	rename_table :notifications, :notifies
  end
end
