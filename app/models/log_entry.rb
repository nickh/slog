=begin rdoc
LogEntry provides a Ruby interface to log entries.  Each log entry must be
associated with a User.
=end

class LogEntry < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :user
end