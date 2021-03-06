=begin rdoc
Boat provides a Ruby interface to boats.  Each boat belongs to a
boat model (eg. boat "S6" is a "Santana 22") and may be referenced
in a log entry.
=end

class Boat < ActiveRecord::Base
  belongs_to :boat_model
  belongs_to :boat_owner
  has_many :log_entries

  validates_uniqueness_of :name
  validates_presence_of :boat_model

  def owner
    self.boat_owner.name rescue ''
  end

  def model
    self.boat_model.name rescue ''
  end

  def description
    '%s (%s %s)' % [self.name, self.owner, self.model]
  end
end