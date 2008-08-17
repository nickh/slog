class User < ActiveRecord::Base
  validates_uniqueness_of :openid_identifier

  has_many :log_entries
end