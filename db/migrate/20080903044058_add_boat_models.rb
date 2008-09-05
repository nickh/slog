class AddBoatModels < ActiveRecord::Migration
  def self.up
    create_table :boat_models do |t|
      t.string :name, :notes
    end
  end

  def self.down
    drop_table :boat_models
  end
end
