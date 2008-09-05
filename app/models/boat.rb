=begin rdoc
Boat provides a Ruby interface to boats.  Each boat belongs to a
boat model (eg. boat "S6" is a "Santana 22") and may be referenced
in a log entry.
=end

class Boat < ActiveRecord::Base
  belongs_to :boat_model

  validates_uniqueness_of :name
end