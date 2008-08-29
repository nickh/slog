require File.dirname(__FILE__) + '/../spec_helper'

describe User do
  fixtures :users, :log_entries

  it 'should respond to user attributes' do
    user = User.new
    user.should respond_to(:openid_identifier)
    user.should respond_to(:nickname)
    user.should respond_to(:fullname)
    user.should respond_to(:email)
  end

  it 'should have many log entries' do
    User.new.should have_many(:log_entries)
  end

  it 'should order log_entries by most to least recent' do
    entries = User.find(:first).log_entries
    entry_ids = entries.collect{|e| e.id}
    entry_ids.should == entry_ids.sort.reverse
  end

  it "should not be valid with a duplicate OpenID identifier" do
    existing_user = User.find(:first)
    new_user = User.new(:openid_identifier => existing_user.openid_identifier)
    new_user.should_not be_valid
  end

  it "should be valid with a unique OpenID identifier" do
    existing_user = User.find(:first)
    openid_identifier = existing_user.openid_identifier
    existing_user.destroy
    new_user = User.new(:openid_identifier => openid_identifier)
    new_user.should be_valid
  end
end
