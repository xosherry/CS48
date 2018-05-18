Rails.application.routes.draw do
  resources :feeds do
    member do
      resources :posts, only: [:index, :show]
    end
  end
  root 'feeds#index'


  resources :feeds
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
