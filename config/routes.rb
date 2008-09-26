ActionController::Routing::Routes.draw do |map|
  # OpenID authentication
  map.resource :login, :member => { :complete => :get, :destroy => :get }
  map.logout 'logout', :controller => 'logins', :action => 'destroy'
  
  # Application resources
  map.resources :log_entries, :member => {:destroy => :get}

  # Boat resources
  map.resources :boats
  map.connect '/boats/create_owner', :controller => 'boats', :action => 'create_owner'
  map.connect '/boats/create_model', :controller => 'boats', :action => 'create_model'

  # Default
  map.root :controller => 'log_entries'
end
