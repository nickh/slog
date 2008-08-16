require 'openid'
require 'openid/extension'
require 'openid/extensions/sreg'
require 'openid/store/filesystem'

class LoginsController < ApplicationController

  def show
    render :action => 'new'
  end

  def new
  end

  def create
    begin
      identifier = params[:openid_identifier]
      if identifier.nil?
        flash[:error] = "Enter an OpenID identifier"
        redirect_to :action => 'new'
        return
      end
      oidreq = consumer.begin(identifier)
    rescue OpenID::OpenIDError => e
      flash[:error] = "Discovery failed for #{identifier}: #{e}"
      redirect_to :action => 'index'
      return
    end

    # attempt to retrieve fields using sreg
    sregreq = OpenID::SReg::Request.new
    sregreq.request_fields(['email','fullname','nickname'], false)
    oidreq.add_extension(sregreq)

    return_to = url_for :action => 'complete', :only_path => false
    realm = url_for :action => 'show', :only_path => false

    if oidreq.send_redirect?(realm, return_to, params[:immediate])
      redirect_to oidreq.redirect_url(realm, return_to, params[:immediate])
    else
      render :text => oidreq.html_markup(realm, return_to, params[:immediate], {'id' => 'openid_form'})
    end
  end

  def complete
    current_url = url_for(:action => 'complete', :only_path => false)
    parameters = params.reject{|k,v|request.path_parameters[k]}
    oidresp = consumer.complete(parameters, current_url)
    case oidresp.status
    when OpenID::Consumer::FAILURE
      if oidresp.display_identifier
        flash[:error] = ("Verification of #{oidresp.display_identifier}"\
                         " failed: #{oidresp.message}")
      else
        flash[:error] = "Verification failed: #{oidresp.message}"
      end
    when OpenID::Consumer::SUCCESS
      flash[:success] = ("Verification of #{oidresp.display_identifier}"\
                         " succeeded.")
      sreg_resp = OpenID::SReg::Response.from_success_response(oidresp)
      user_info = sreg_resp.data.merge({:openid_identifier => oidresp.display_identifier})
      if (user = User.find_or_create_by_openid_identifier(user_info))
        session[:user]  = user
        flash[:success] = 'OpenID login successful'
      end
    when OpenID::Consumer::SETUP_NEEDED
      flash[:alert] = "Immediate request failed - Setup Needed"
    when OpenID::Consumer::CANCEL
      flash[:alert] = "OpenID transaction cancelled."
    else
    end

    redirect_to root_url
  end

  def destroy
    session[:user] = nil
    redirect_to root_url
  end

  protected

    def consumer
      @openid_consumer ||= OpenID::Consumer.new(session, OpenID::Store::Filesystem.new("#{RAILS_ROOT}/tmp/openid"))
    end

end