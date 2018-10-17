Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get 'gift-card/:id', to: 'business_landing_pages#show'
end
