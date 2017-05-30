require 'api_constraints'

Rails.application.routes.draw do

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"

  namespace :api, defaults: { format: :json }, path: '/' do
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do
      resources :users, only: [:show, :create, :update, :destroy] do
          get 'showFriendship' => 'users#show_friendship', on: :member
          post 'createFriendships' => 'users#friend_request', on: :member
          get 'indexFriendships' => 'users#index_friendships', on: :collection
          patch 'acceptRequest' => 'users#accept_request', on: :collection
      end
      devise_for :users, only: :sessions
      resources :notifications, only: [:index, :show]
      #resources :friendships, only: [:index, :create]
    end
  end

  root 'pages#index'

  get ':id' => 'users#show'
  post 'searchUsers' => 'users#search_users'
  post 'appendPosts' => 'posts#append_posts'
  post 'createPost' => 'posts#create'
  get 'getPost' => 'posts#get'
  put 'updatePost' => 'posts#update'
  delete 'deletePost' => 'posts#destroy'



  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
