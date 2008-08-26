class CreateLogEntries < ActiveRecord::Migration
  def self.up
    create_table :log_entries do |t|
      t.timestamps
      t.datetime   :departed_at , :arrived_at
      t.string     :origin      , :destination
      t.integer    :days_onboard, :night_hours
      t.text       :notes
    end
  end

  def self.down
    drop_table :log_entries
  end
end
