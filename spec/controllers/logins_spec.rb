require File.dirname(__FILE__) + '/../spec_helper'

describe LoginsController, "with an OpenID identifier" do
  test_identifier = 'http://my.openid.id'

  before(:each) do
    User.stub!(:find_or_create_by_openid_identifier).and_return(@user = mock_model(User, :save=>true))
    @oidreq  = mock("oidreq")
    @oidresp = mock("oidresp")
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

  it "should set the user session on successful completion" do
    OpenID::SReg::Response.stub!(:from_success_response => mock("sregdata", :data => {}))
    
    @oidresp.should_receive(:status).and_return(OpenID::Consumer::SUCCESS)
    @oidresp.should_receive(:display_identifier).twice.and_return(test_identifier)
    @openid_consumer.should_receive(:complete).and_return(@oidresp)
    get :complete
    response.should be_redirect
    session[:user].should_not be_nil
  end

end
