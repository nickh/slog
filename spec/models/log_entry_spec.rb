require File.dirname(__FILE__) + '/../spec_helper'

describe LogEntry, "new entries" do
  before(:each) do
    @entry = LogEntry.new(
      :departed_at => '2008-08-10 12:00:00',
      :arrived_at  => '2008-08-10 16:00:00'
    )
  end

  it "should respond to log_entry attributes" do
    @entry.should respond_to(:departed_at)
    @entry.should respond_to(:arrived_at)
    @entry.should respond_to(:origin)
    @entry.should respond_to(:destination)
    @entry.should respond_to(:days_onboard)
    @entry.should respond_to(:night_hours)
    @entry.should respond_to(:notes)
  end

  it "should be valid" do
    @entry.should be_valid
  end

  it "should be invalid without dates" do
    @entry.departed_at = nil
    @entry.arrived_at  = nil
    @entry.should_not be_valid
    @entry.should have(1).error_on(:departed_at)
    @entry.should have(1).error_on(:arrived_at)
  end

end

describe LogEntry, "with fixtures" do
  fixtures :log_entries

  before(:each) do
    @entry = LogEntry.find(log_entries(:valid_entry).id)
  end
end