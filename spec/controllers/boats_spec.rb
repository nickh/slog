require File.dirname(__FILE__) + '/../spec_helper'

describe BoatsController do
  fixtures :boats

  it 'should display a list of boats' do
    get :index
    assigns[:boats].should_not be_nil
    assigns[:owners].should_not be_nil
    assigns[:models].should_not be_nil
    response.should render_template(:index)
  end

  describe '(with a logged-in user)' do
    before(:each) do
      login
    end

    it 'should not respond to destroy' do
      lambda {get :destroy, :id => boats(:valid_boat).id}.should raise_error(ActionController::UnknownAction)
    end

    it 'should return a new boat form' do
      get :new
      assigns[:boat].should_not be_nil
      flash[:error].should be_nil
      response.should be_success
      response.should render_template(:new)
    end

    it 'should add a valid boat' do
      create_mock_valid(Boat, :verify_assigns => :boat) do
        post :create
        response.should be_redirect
      end
    end

    it 'should not add an invalid boat' do
      create_mock_invalid(Boat, :verify_assigns => :boat) do
        post :create
        response.should be_redirect
      end
    end

    it 'should return an edit boat form for an existing boat' do
      get :edit, :id => boats(:valid_boat).id
      assigns[:boat].should_not be_nil
      flash[:error].should be_nil
      response.should be_success
      response.should render_template(:edit)
    end

    it 'should not return an edit boat form for a nonexistent boat' do
      boat = Boat.find(:first)
      boat.destroy
      get :edit, :id => boat.id
      flash[:error].should_not be_nil
      response.should be_redirect
    end

    it 'should not route an edit request without an id' do
      lambda{ get :edit }.should raise_error(ActionController::RoutingError)
    end

    it 'should update a boat with valid parameters' do
      boat = boats(:valid_boat)
      post :update, :id => boat.id, :boat => boat.attributes
      assigns[:boat].should_not be_nil
      flash[:error].should be_nil
      response.should be_redirect
    end

    it 'should not update a boat with invalid parameters' do
      boat = Boat.find(:first)
      Boat.stub!(:find).and_return(mock_boat = mock_model(Boat, :valid => false))
      post :update, :id => boat.id, :boat => boat.attributes
      assigns[:boat].should_not be_nil
      flash[:error].should_not be_nil
      response.should be_success
      response.should render_template(:edit)
    end

    it 'should not update a nonexistent boat' do
      boat = Boat.find(:first)
      boat.destroy
      post :update, :id => boat.id, :boat => boat.attributes
      assigns[:boat].should be_nil
      flash[:error].should_not be_nil
      response.should be_redirect
    end

    it 'should not route an update request without an id' do
      lambda{ get :update }.should raise_error(ActionController::RoutingError)
    end

    it 'should add a valid boat model' do
      create_mock_valid(BoatModel, :verify_assigns => :model) do
        post :create_model
        response.should be_redirect
      end
    end

    it 'should not add an invalid boat model' do
      create_mock_invalid(BoatModel, :verify_assigns => :model) do
        post :create_model
        response.should be_redirect
      end
    end

    it 'should add a valid boat owner' do
      create_mock_valid(BoatOwner, :verify_assigns => :owner) do
        post :create_owner
        response.should be_redirect
      end
    end

    it 'should not add an invalid boat owner' do
      create_mock_invalid(BoatOwner, :verify_assigns => :owner) do
        post :create_owner
        response.should be_redirect
      end
    end
  end

  describe '(with a guest account)' do
    before(:each) do
      logout
    end

    it 'should not display a new boat form' do
      get :new
      assigns[:boat].should be_nil
      response.response_code.should == 401
    end

    it 'should not create a new boat' do
      post :create
      assigns[:boat].should be_nil
      response.response_code.should == 401
    end

    it 'should not display a boat edit form' do
      get :edit, :id => boats(:valid_boat).id
      assigns[:boat].should be_nil
      response.response_code.should == 401
    end

    it 'should not update an existing boat' do
      boat = boats(:valid_boat)
      post :update, :id => boat.id, :boat => boat.attributes
      assigns[:boat].should be_nil
      response.response_code.should == 401
    end

    it 'should not delete an existing boat' do
      existing_boat = boats(:valid_boat).id
      get :destroy, :id => existing_boat
      response.response_code.should == 401
      Boat.find(existing_boat).should_not be_nil
    end

    it 'should not add a boat model' do
      post :create_model
      assigns[:model].should be_nil
      response.response_code.should == 401
    end

    it 'should not add a boat owner' do
      post :create_owner
      assigns[:owner].should be_nil
      response.response_code.should == 401
    end
  end
end