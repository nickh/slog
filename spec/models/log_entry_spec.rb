require File.dirname(__FILE__) + '/../spec_helper'

describe LogEntry do
  it 'should respond to class methods' do
  end

  it 'should respond to log_entry attributes' do
    entry = LogEntry.new
    entry.should respond_to(:departed_at)
    entry.should respond_to(:arrived_at)
    entry.should respond_to(:origin)
    entry.should respond_to(:destination)
    entry.should respond_to(:days_onboard)
    entry.should respond_to(:night_hours)
    entry.should respond_to(:notes)
    entry.should belong_to(:user)
  end

  it 'should not be valid without a user' do
    entry = LogEntry.new(:user => nil)
    entry.should_not be_valid
  end
end
