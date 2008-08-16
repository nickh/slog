require File.dirname(__FILE__) + '/../spec_helper'

describe User, "new entries" do
  fixtures :users

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
