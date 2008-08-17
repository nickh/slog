class LogEntry < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :user

  def self.user_entries(user_id)
    self.find(:all, :conditions => ['user_id=?', user_id], :order => 'id DESC')
  end
  
  def self.recent_entries
    
  end
end