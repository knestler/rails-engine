Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/api/v1/items/:id/merchant', to: 'api/v1/merchants#show'
  
  namespace :api do
    namespace :v1 do
      resources :items do
        resources :merchant, only: [:show], controller: :merchants
      end 

      resources :merchants, only: [:index, :show] do 
        resources :items, only: [:index]
      end
      
    end
  end

  # get '/api/v1/merchants/:id/items', to: 'item#index'
end
