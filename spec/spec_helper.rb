# This file is copied to ~/spec when you run 'ruby script/generate rspec'
# from the project root directory.
ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'spec'
require 'spec/rails'

Spec::Runner.configure do |config|
  # If you're not using ActiveRecord you should remove these
  # lines, delete config/database.yml and disable :active_record
  # in your config/boot.rb
  config.use_transactional_fixtures = true
  config.use_instantiated_fixtures  = false
  config.fixture_path = RAILS_ROOT + '/spec/fixtures/'

  # == Fixtures
  #
  # You can declare fixtures for each example_group like this:
  #   describe "...." do
  #     fixtures :table_a, :table_b
  #
  # Alternatively, if you prefer to declare them only once, you can
  # do so right here. Just uncomment the next line and replace the fixture
  # names with your fixtures.
  #
  # config.global_fixtures = :table_a, :table_b
  #
  # If you declare global fixtures, be aware that they will be declared
  # for all of your examples, even those that don't use them.
  #
  # You can also declare which fixtures to use (for example fixtures for test/fixtures):
  #
  # config.fixture_path = RAILS_ROOT + '/spec/fixtures/'
  #
  # == Mock Framework
  #
  # RSpec uses it's own mocking framework by default. If you prefer to
  # use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  #
  # == Notes
  # 
  # For more information take a look at Spec::Example::Configuration and Spec::Runner

  config.include(ActiveRecordMatchers)
end

# Helper methods
def login(user_id = :first)
  @test_user = User.find(user_id)
  session[:user] = @test_user
end

def logout
  session[:user] = nil
end

def create_mock_valid(klass, options={})
  mock_object = mock_model(klass) do |obj|
    obj.should_receive(:save!).and_return(true)
  end
  klass.stub!(:new).and_return(mock_object)

  yield

  if verify_assigns = options[:verify_assigns]
    verify_assigns = [verify_assigns] unless verify_assigns.is_a? Array
    verify_assigns.each do |a|
      assigns[a].should_not be_nil
    end
  end
  flash[:notice].should_not be_nil
  flash[:error].should be_nil
end

def create_mock_invalid(klass, options={})
  mock_object = mock_model(klass) do |obj|
    obj.should_receive(:save!).and_raise(ActiveRecord::RecordInvalid)
  end
  klass.stub!(:new).and_return(mock_object)

  yield

  if assigns = options[:assigns]
    assigns = [assigns] unless assigns.is_a? Array
    assigns.each do |a|
      assigns[a].should_not be_nil
    end
  end
  flash[:notice].should be_nil
  flash[:error].should_not be_nil
end
