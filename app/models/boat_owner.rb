=begin rdoc
BoatOwner provides a Ruby interfact to boat owners.  Each boat must belong
to one owner, and each owner may have many boats.
=end

class BoatOwner < ActiveRecord::Base
  has_many :boats

  validates_uniqueness_of :name
end