Rails.application.routes.draw do
   resources :articles, only: %i[index show new create destroy]

  root "articles#index"
end
