# Configure your routes here
# See: http://hanamirb.org/guides/routing/overview/
#
# Example:
# get '/hello', to: ->(env) { [200, {}, ['Hello from Hanami!']] }
root to: 'user#index'
resources :users, only: [:index, :create]
get '/user/new', to: 'user#new'
