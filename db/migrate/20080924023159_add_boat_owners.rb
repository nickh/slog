class AddBoatOwners < ActiveRecord::Migration
  def self.up
    create_table :boat_owners do |t|
      t.string :name, :notes
    end
  end

  def self.down
    drop_table :boat_owners
  end
end
