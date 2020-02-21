Rails.application.routes.draw do
  get 'news/list-by-user' => 'news#list_by_user'
  put 'news/add-to-favorites' => 'news#add_to_favorites'
  get 'news/list-unreaded' => 'news#list_unreaded'
  resources :news
  resources :users
  mount_devise_token_auth_for 'User', at: 'auth'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
