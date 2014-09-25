Rails.application.routes.draw do
  resources :posts

  resources :categories do
    resources :posts
  end

  root 'categories#index'

  # show page related to slug
  get '/:slug' => 'pages#show'
end
