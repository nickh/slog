class AddLogEntryBoatAssociation < ActiveRecord::Migration
  def self.up
    add_column :log_entries, :boat_id, :integer
  end

  def self.down
    remove_column :log_entries, :boat_id
  end
end
