require File.dirname(__FILE__) + '/../spec_helper'

describe LogEntriesController, 'index' do
  fixtures :log_entries, :users

  it 'should return a JSON list' do
    get :index, :format => 'json'
    assigns[:entries].should_not be_nil
    response.should be_success
  end

  it 'should not return an HTML list' do
    get :index, :format => :html
    response.should_not be_success
  end

  it 'should not return an XML list' do
    get :index, :format => :xml
    response.should_not be_success
  end  

  describe '(with a logged in user)' do
    before(:each) do
      @test_user = User.find(1)
      session[:user] = @test_user
    end
    
    it 'should not return entries for other users' do
      get :index, :format => 'json'
    
      foreign_entries = assigns[:entries].select{|e| e.user != @test_user}
      foreign_entries.should be_empty
    end
    
    it 'should include complete and incomplete entries' do
      get :index, :format => 'json'
    
      completed_entries  = assigns[:entries].select{|e| !e.arrived_at.nil?}
      incomplete_entries = assigns[:entries].select{|e|  e.arrived_at.nil?}
    
      completed_entries.should_not  be_empty
      incomplete_entries.should_not be_empty
    end
  end

  describe '(with a guest account)' do
    before(:each) do
      session[:user] = nil
    end
    
    it 'should not return more than 20 items' do
      get :index, :format => 'json'
    
      assigns[:entries].should have_at_most(20).items
    end
    
    it 'should return entries for multiple users' do
      get :index, :format => 'json'
    
      unique_users = assigns[:entries].collect{|e| e.user_id}.uniq
      unique_users.should have_at_least(2).items
    end
    
    it 'should not return incomplete entries' do
      get :index, :format => 'json'
    
      incomplete_entries = assigns[:entries].select{|e| e.arrived_at.nil?}
      incomplete_entries.should be_empty
    end
  end
  
end
