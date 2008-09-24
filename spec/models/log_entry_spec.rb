require File.dirname(__FILE__) + '/../spec_helper'

describe LogEntry do
  fixtures :boats, :boat_models

  it 'should respond to log_entry attributes' do
    entry = LogEntry.new
    entry.should respond_to(:departed_at)
    entry.should respond_to(:arrived_at)
    entry.should respond_to(:origin)
    entry.should respond_to(:destination)
    entry.should respond_to(:days_onboard)
    entry.should respond_to(:night_hours)
    entry.should respond_to(:notes)
  end

  it 'should belong to a user' do
    LogEntry.new.should belong_to(:user)
  end

  it 'should belong to a boat' do
    LogEntry.new.should belong_to(:boat)
  end

  it 'should not be valid without a user' do
    entry = LogEntry.new(:user => nil)
    entry.should_not be_valid
  end
end
