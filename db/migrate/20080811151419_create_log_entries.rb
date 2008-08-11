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

=begin
@entry.should.respond_to?(:departed_at)
@entry.should.respond_to?(:arrived_at)
@entry.should.respond_to?(:origin)
@entry.should.respond_to?(:destination)
@entry.should.respond_to?(:days_onboard)
@entry.should.respond_to?(:night_hours)
@entry.should.respond_to?(:notes)
=end

  def self.down
    drop_table :log_entries
  end
end
