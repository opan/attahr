root to: 'users#index'

resources :users

get '/sign_in', to: 'sessions#new'
post '/sign_in', to: 'sessions#create', as: 'sign_in'
get '/sign_up', to: 'users#sign_up', as: 'sign_up'
post '/sign_up', to: 'users#register', as: 'register_user'
get '/unauthenticated', to: 'sessions#new'
