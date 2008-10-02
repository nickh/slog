require File.dirname(__FILE__) + '/../spec_helper'

describe BoatModel do
  fixtures :boat_models

  it 'should respond to boat_model attributes' do
    model = BoatModel.new
    model.should respond_to(:name)
    model.should respond_to(:notes)
  end

  it 'should have many boats' do
    BoatModel.new.should have_many(:boats)
  end

  it "should not be valid with a duplicate name" do
    existing_model = BoatModel.find(:first)
    new_model = BoatModel.new(:name => existing_model.name)
    new_model.should_not be_valid
  end

  it 'should not be valid with a nil name' do
    BoatModel.new(:name => nil).should_not be_valid
  end

  it 'should not be valid with an empty name' do
    BoatModel.new(:name => '').should_not be_valid
  end

  it "should be valid with a unique name" do
    existing_model = BoatModel.find(:first)
    existing_model.destroy
    new_model = BoatModel.new(:name => existing_model.name)
    new_model.should be_valid
  end
end
