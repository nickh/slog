require File.dirname(__FILE__) + '/../spec_helper'

describe LoginsController, "create with an OpenID identifier" do
  fixtures :users

  test_identifier = 'http://my.openid.id'

  before(:each) do
    User.stub!(:find_or_create_by_openid_identifier).and_return(@user = mock_model(User, :save=>true))
    @oidreq  = mock("oidreq")
    @oidresp = mock("oidresp")
    @oidresp.stub!(:display_identifier).and_return(test_identifier)
    @oidresp.stub!(:message).and_return('')
    OpenID::Consumer.stub!(:new).and_return(@openid_consumer=mock("consumer"))
  end

  it "should begin OpenID authentication" do
    @oidreq.should_receive(:add_extension).and_return(true)
    @oidreq.should_receive(:send_redirect?).and_return(true)
    @oidreq.should_receive(:redirect_url).and_return('http://test.redirect.url')
    @openid_consumer.should_receive(:begin).and_return(@oidreq)
    get :create, :openid_identifier => test_identifier
    response.should be_redirect
  end

  it "should set the user session if complete succeeded" do
    OpenID::SReg::Response.stub!(:from_success_response => mock("sregdata", :data => {}))
    @oidresp.stub!(:status).and_return(OpenID::Consumer::SUCCESS)
    @openid_consumer.should_receive(:complete).and_return(@oidresp)
    get :complete
    response.should be_redirect
    session[:user].should_not be_nil
    flash[:success].should_not be_nil
    flash[:error].should be_nil
    flash[:alert].should be_nil
  end

  it "should clear the user session if complete failed" do
    session[:user] = User.find(:first)
    @oidresp.stub!(:status).and_return(OpenID::Consumer::FAILURE)
    @openid_consumer.should_receive(:complete).and_return(@oidresp)
    get :complete
    response.should be_redirect
    session[:user].should be_nil
    flash[:success].should be_nil
    flash[:error].should_not be_nil
    flash[:alert].should be_nil
  end

  it "should clear the user session if complete needs setup" do
    session[:user] = User.find(:first)
    @oidresp.stub!(:status).and_return(OpenID::Consumer::SETUP_NEEDED)
    @openid_consumer.should_receive(:complete).and_return(@oidresp)
    get :complete
    response.should be_redirect
    session[:user].should be_nil
    flash[:success].should be_nil
    flash[:error].should be_nil
    flash[:alert].should_not be_nil
  end

  it "should clear the user session if complete canceled" do
    session[:user] = User.find(:first)
    @oidresp.stub!(:status).and_return(OpenID::Consumer::CANCEL)
    @openid_consumer.should_receive(:complete).and_return(@oidresp)
    get :complete
    response.should be_redirect
    session[:user].should be_nil
    flash[:success].should be_nil
    flash[:error].should be_nil
    flash[:alert].should_not be_nil
  end

end
