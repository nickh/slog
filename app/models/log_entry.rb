class LogEntry < ActiveRecord::Base
  # TODO: certified_by (foreign key?), equipment_used (equipment types, reg#)
  validates_presence_of :departed_at, :arrived_at
end