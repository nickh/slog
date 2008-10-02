=begin rdoc
BoatModel provides a Ruby interface to boat models.  Each boat model may
have multiple boats of that type (eg. boats "S2", "S4", "S6" are all
"Santana 22" models)
=end

class BoatModel < ActiveRecord::Base
  has_many :boats

  validates_uniqueness_of :name
  validates_presence_of   :name
end