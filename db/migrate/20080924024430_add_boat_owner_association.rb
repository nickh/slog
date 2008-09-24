class AddBoatOwnerAssociation < ActiveRecord::Migration
  def self.up
    add_column :boats, :boat_owner_id, :integer
  end

  def self.down
    remove_column :boats, :boat_owner_id
  end
end
