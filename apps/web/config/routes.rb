root to: 'users#index'

resources :users

get '/sign_in', to: 'sessions#new'
post '/sign_in', to: 'sessions#create', as: 'sign_in'
get '/unauthenticated', to: 'sessions#new'
