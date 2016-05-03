Rails.application.routes.draw do
#  resources :saverecords
  resources :savings do
    collection do
      get "download"
      get "search"
      get :exp_sandr_csv
    end
  end

  resources :saverecords do
    collection do
      get :search
      get :export_csv
    end
  end

#  resources :saverecords, only: [:index]

#  resources :savings

#  resources :incomes
  resources :incomes do
    collection do
      get "download"
      get "sumishow"
      get "search"
      get :export_csv
      get :sumicsv
    end
    member do
      get :copy
    end
  end

# new1rec_expense_path=/expenses/:id/new1recとなってしまう
#  resources :expenses do
#    member { get "new1rec"  }
#  end

#  resources :expenses
  resources :expenses do
    collection do
      get "download"
      get "sumexshow"
      get "search"
      get :export_csv
      get :sumexcsv
    end
    member do
      post :createone
      get :copy
    end
  end


#  get "expenses/new1rec" => "expenses#new1rec"

  # You can have the root of your site routed with "root"
#  get 'top/index'
  #/ pageのコントがTopControllerのindexアクションと指定
  root :to =>'top#index'
  get "about" => "top#about", as: "about"
#Excel出力用
#  controller :report do
#    get 'report' => 'report#index', as: :report
#    get 'report/output', as: :output_report
#  end


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
