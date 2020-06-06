root to: 'users#index'

resources :users

post '/sign_in/unauthenticated', to: 'sessions#new'
get '/sign_in', to: 'sessions#new'
post '/sign_in', to: 'sessions#create'
