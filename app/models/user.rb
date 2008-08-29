=begin rdoc
User provides a local reference to an OpenID account that has been used
to access the system.  The first time an OpenID account is used to access
the system, a new User object will be automatically created and if the OpenID
server supports it and the user permits it, the new account will be
automatically populated with the OpenID persona's full name, nickname, and
email address.
=end

class User < ActiveRecord::Base
  validates_uniqueness_of :openid_identifier

  has_many :log_entries, :order => 'id DESC'
end