# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  before_filter :check_login

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery :secret => 'edc9493c014d3d7699ace5d4f8c1c703'
  
  private

  def check_login
    # TODO: session expiration
    @current_user = session[:user]
  end
end
