require File.dirname(__FILE__) + '/../spec_helper'

describe Boat do
  fixtures :boats

  it 'should respond to boat attributes' do
    boat = Boat.new
    boat.should respond_to(:name)
    boat.should respond_to(:notes)
  end

  it 'should belong to a boat model' do
    Boat.new.should belong_to(:boat_model)
  end

  it "should not be valid with a duplicate name" do
    existing_boat = Boat.find(:first)
    new_boat = Boat.new(:name => existing_boat.name)
    new_boat.should_not be_valid
  end

  it "should be valid with a unique name" do
    existing_boat = Boat.find(:first)
    existing_boat.destroy
    new_boat = Boat.new(:name => existing_boat.name)
    new_boat.should be_valid
  end
end
