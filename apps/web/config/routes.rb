root to: 'users#index'

resources :users

get '/sign_in', to: 'sessions#new'
post '/sign_in', to: 'sessions#create'
get '/unauthenticated', to: 'sessions#new'
