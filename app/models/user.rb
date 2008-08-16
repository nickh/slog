class User < ActiveRecord::Base
  validates_uniqueness_of :openid_identifier
end