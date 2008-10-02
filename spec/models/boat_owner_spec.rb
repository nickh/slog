require File.dirname(__FILE__) + '/../spec_helper'

describe BoatOwner do
  fixtures :boat_owners

  it 'should respond to boat_owner attributes' do
    model = BoatOwner.new
    model.should respond_to(:name)
    model.should respond_to(:notes)
  end

  it 'should have many boats' do
    BoatOwner.new.should have_many(:boats)
  end

  it "should not be valid with a duplicate name" do
    existing_owner = BoatOwner.find(:first)
    new_owner = BoatOwner.new(:name => existing_owner.name)
    new_owner.should_not be_valid
  end

  it 'should not be valid with a nil name' do
    BoatOwner.new(:name => nil).should_not be_valid
  end

  it 'should not be valid with an empty name' do
    BoatOwner.new(:name => '').should_not be_valid
  end

  it "should be valid with a unique name" do
    existing_owner = BoatOwner.find(:first)
    existing_owner.destroy
    new_owner = BoatOwner.new(:name => existing_owner.name)
    new_owner.should be_valid
  end
end
