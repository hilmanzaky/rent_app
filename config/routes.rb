BlackstarRentApp::Application.routes.draw do

  root :to => 'sessions#new'

  namespace :admin do
    root :to => 'products#index'
    resources :users

    resources :product_stocks do
      resources :stock_histories, :only => [:index]
    end

    resources :products do
      get 'order'
      resources :ordered_products, :only => [:new, :create]
      resources :product_stocks, :only => [:new, :create, :show, :index]
      resources :orders, :only => [] do
        resources :ordered_products, :only => [:new]
      end
    end

    resources :ordered_products do
      member do
        put :set_sub_total
      end
    end

    resources :orders do
      get 'edit_detail'
      collection do
        get 'payments'
        get 'books'
        get 'build'
      end

      get 'print_original'
      get 'print'
      get 'print_deliver'
#      get 'return_of_products'
#      resources :return_products, :only => [:new]
      resources :payments, :only => [:index, :new]
      resources :rented_products, :only => [:index]
    end

    resources :returned_products, :only => [:create]

    resources :payments, :only => [:create, :edit, :update, :destroy]
    
    resources :product do
      resources :product_packages, :only => [:new, :destroy]
    end
    
    resources :product_packages, :only => [:create]


#    resources :return_products, :except => [:new]
  end

  resources :users
  resources :sessions

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
  # match ':controller(/:action(/:id(.:format)))'
end
