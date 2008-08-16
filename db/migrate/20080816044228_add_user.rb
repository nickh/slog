class AddUser < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :openid_identifier, :nickname, :fullname, :email
    end
  end

  def self.down
    drop_table :users
  end
end
