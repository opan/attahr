root to: 'products#index'
get '/products', to: 'products#index'

get '/sign_in', to: 'sessions#new'
post '/sign_in', to: 'sessions#create', as: 'sign_in'
delete '/sign_out', to: 'sessions#destroy', as: 'sign_out'
get '/sign_up', to: 'users#sign_up', as: 'sign_up'
post '/sign_up', to: 'users#register', as: 'register_user'
get '/unauthenticated', to: 'sessions#new'

resources :orgs, except: [:destroy] do
  member do
    get :members
  end
end

delete '/orgs/:id/members/remove/:member_id', to: 'orgs#remove_members', as: 'remove_members_org'
