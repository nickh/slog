require File.dirname(__FILE__) + '/../spec_helper'

# Helper methods
def login(user_id = :first)
  @test_user = User.find(user_id)
  session[:user] = @test_user
end

def logout
  session[:user] = nil
end


describe LogEntriesController do
  fixtures :log_entries, :users

  it 'should return a JSON list' do
    get :index, :format => 'json'
    assigns[:entries].should_not be_nil
    response.should be_success
  end

  it 'should return an HTML list' do
    get :index
    assigns[:entries].should_not be_nil
    response.should be_success
  end

  describe '(with a logged in user)' do
    before(:each) do
      login
    end
    
    it 'should not return list entries for other users' do
      get :index, :format => 'json'
    
      foreign_entries = assigns[:entries].select{|e| e.user != @test_user}
      foreign_entries.should be_empty
    end
    
    it 'should include complete and incomplete list entries' do
      get :index, :format => 'json'
    
      completed_entries  = assigns[:entries].select{|e| !e.arrived_at.nil?}
      incomplete_entries = assigns[:entries].select{|e|  e.arrived_at.nil?}
    
      completed_entries.should_not  be_empty
      incomplete_entries.should_not be_empty
    end

    it 'should return a new log_entry form' do
      get :new
      assigns[:entry].should_not be_nil
      flash[:error].should be_nil
      response.should be_success
    end

    it 'should add a valid log entry to the list' do
      post :create
      assigns[:entry].should_not be_nil
      flash[:error].should be_nil
      response.should be_redirect
    end

    it 'should not add an invalid log entry to the list' do
      LogEntry.stub!(:new).and_return(@entry = mock_model(LogEntry, :valid => false))
      post :create
      assigns[:entry].should_not be_nil
      flash[:error].should_not be_nil
      response.should be_redirect
    end

    it 'should return an edit log_entry form for an existing entry' do
      get :edit, :id => log_entries(:valid_entry).id
      assigns[:entry].should_not be_nil
      flash[:error].should be_nil
      response.should be_success
    end

    it 'should not return an edit log_entry form for a nonexistent entry' do
      entry = LogEntry.find(:first)
      entry.destroy
      get :edit, :id => entry.id
      flash[:error].should_not be_nil
      response.should be_redirect
    end

    it 'should not route an edit request without an id' do
      lambda{ get :edit }.should raise_error
    end

    it 'should update a log entry with valid parameters' do
      entry = log_entries(:valid_entry)
      post :update, :id => entry.id, :log_entry => entry.attributes
      assigns[:entry].should_not be_nil
      flash[:error].should be_nil
      response.should be_redirect
    end

    it 'should not update a log entry with invalid parameters' do
      entry = LogEntry.find(:first, :conditions => ['user_id = ?', session[:user].id])
      LogEntry.stub!(:find).and_return(mock_entry = mock_model(LogEntry, :valid => false))
      post :update, :id => entry.id, :log_entry => entry.attributes
      assigns[:entry].should_not be_nil
      flash[:error].should_not be_nil
      response.should be_success
    end

    it 'should not update a nonexistent log entry' do
      entry = LogEntry.find(:first, :conditions => ['user_id = ?', session[:user].id])
      entry.destroy
      post :update, :id => entry.id, :log_entry => {'user_id' => nil}
      assigns[:entry].should be_nil
      flash[:error].should_not be_nil
      response.should be_redirect
    end

    it "should not update another user's log entry" do
      entry = LogEntry.find(:first, :conditions => ['user_id != ?', session[:user].id])
      post :update, :id => entry.id, :log_entry => entry.attributes
      assigns[:entry].should be_nil
      flash[:error].should_not be_nil
      response.should be_redirect
    end

    it 'should not route an update request without an id' do
      lambda{ get :update }.should raise_error
    end
  end

  describe '(with a guest account)' do
    before(:each) do
      logout
    end
    
    it 'should not return more than 20 list items' do
      get :index, :format => 'json'
    
      assigns[:entries].should have_at_most(20).items
    end
    
    it 'should return list entries for multiple users' do
      get :index, :format => 'json'
    
      unique_users = assigns[:entries].collect{|e| e.user_id}.uniq
      unique_users.should have_at_least(2).items
    end
    
    it 'should not return incomplete list entries' do
      get :index, :format => 'json'
    
      incomplete_entries = assigns[:entries].select{|e| e.arrived_at.nil?}
      incomplete_entries.should be_empty
    end

    it 'should not display a new log entry form' do
      get :new
      assigns[:entry].should be_nil
      response.response_code.should == 401
    end

    it 'should not create a new log entry' do
      post :create
      assigns[:entry].should be_nil
      response.response_code.should == 401
    end

    it 'should not display a log entry edit form' do
      get :edit, :id => log_entries(:valid_entry).id
      assigns[:entry].should be_nil
      response.response_code.should == 401
    end

    it 'should not update an existing log entry' do
      entry = log_entries(:valid_entry)
      post :update, :id => entry.id, :log_entry => entry.attributes
      assigns[:entry].should be_nil
      response.response_code.should == 401
    end
  end
  
end
