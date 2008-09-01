ActionController::Routing::Routes.draw do |map|
  # OpenID authentication
  map.resource :login, :member => { :complete => :get, :destroy => :get }
  map.logout 'logout', :controller => 'logins', :action => 'destroy'
  
  # Application resources
  map.resources :log_entries, :member => {:destroy => :get}

  # Default
  map.root :controller => 'log_entries'
end
