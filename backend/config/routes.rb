# -*- encoding : utf-8 -*-
Discount::Application.routes.draw do
  resources :expenses

  resources :tags

  resources :cash_docs

  controller :item_docs do
	post 'item_docs/filter' => :index
  end
  
  resources :item_docs

  resources :stocks

  match 'create_auto_doc/:data' => 'item_docs#create_auto_doc'
 
  match 'stocks/value/:id/:price_id' => 'stocks#value'
  
  match 'stocks/:id/:price_id' => 'stocks#show'
  
  resources :price_types

  match 'goods/load'=>'goods#load'

  resources :goods

  controller :goods do
    post 'search' => :search
	post 'goods/rename' => :rename
  end
  

  get "sessions/new"

  get "sessions/create"

  get "sessions/destroy"

  resources :users

  resources :cards do
     resources :interests
  end

  controller :sessions do
    get 'login' => :new
    post 'login' => :create
    get 'logout' => :destroy
  end
  
  controller :parse  do
    post 'parse' => :index
	get 'parse' =>  :index
  end
  
  controller :price do
	post 'price_update' => :update
  end
  
  match 'incomes_and_expenses' => 'incomes_and_expenses#index'
  match 'incomes_and_expenses/:period' => 'incomes_and_expenses#by_period'
  
  match 'buyers' => 'cards#buyers'
  match 'suppliers' => 'cards#suppliers'
  match 'cards/new/:id' => 'cards#new'
  match 'tags_flat'=>'tags#flat'
   
  match 'price/:id/:pid/:target' => 'price#show'
  
  match 'goods/tag/:tag' => 'goods#tag_index'
  match 'jtags/:target' => 'tags#index'
  match 'goods/tag/:tag/:target' => 'goods#tag_index'
  match 'item_docs/copy/:id' => 'item_docs#copy'
  match 'item_docs/invert/:id' => 'item_docs#invert'
  match 'rests' => 'goods#get_rest'
  
  root :to=> 'sessions#new'

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
