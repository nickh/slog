class AddBoats < ActiveRecord::Migration
  def self.up
    create_table :boats do |t|
      t.string :name, :notes
      t.references :boat_model
    end
  end

  def self.down
    drop_table :boats
  end
end
