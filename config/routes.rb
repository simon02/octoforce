require 'sidekiq/web'

Rails.application.routes.draw do
  # mountain things
  mount Sidekiq::Web, at: '/sidekiq'
  mount SuperfeedrEngine::Engine => SuperfeedrEngine::Engine.base_path # Use the same to set path in the engine initialization!


  namespace :admin do
    # get "/stats" => "stats#stats"
    devise_scope :admin_user do
      get '/stats/:scope' => "stats#stats", as: :admin_stats
    end
  end

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users, class_name: 'FormUser', :controllers => { omniauth_callbacks: 'omniauth_callbacks', registrations: 'registrations', sessions: 'sessions' }
  root 'queue#index'
  get '/setup' => 'setup#index'

  get '/welcome' => 'onboarding#step1'
  get '/welcome/step0' => 'onboarding#step1'
  get '/welcome/step1' => 'onboarding#step1'
  get '/welcome/step2' => 'onboarding#step2'
  get '/welcome/step3' => 'onboarding#step3'
  get '/welcome/step4' => 'onboarding#step4'

  resources :schedules, only: :index do
    post '/add_timeslot' => 'schedules#add_timeslot'
  end
  resources :categories do
    resources :posts, only: [:create]
    get '/posts/bulk' => 'posts#show_bulk'
    post '/posts/preview' => 'posts#bulk_preview'
    post '/posts/bulk' => 'posts#create_bulk'
    # get '/add_in_bulk' => 'categories#add_in_bulk'
    # post '/add_in_bulk/preview' => 'categories#preview_add_in_bulk'
    # post '/add_in_bulk' => 'categories#post_add_in_bulk'
    # post '/add_post' => 'categories#add_post'
    # post '/batch_add_post' => 'categories#batch_add_post'
    # post '/remove_post/:post_id' => 'categories#remove_post'
  end
  resources :feeds, only: [:index, :create, :edit, :destroy]
  resources :identities, path: 'accounts'
  resources :posts, only: [:update, :edit, :destroy, :create]
  resources :timeslots, only: [:new, :create, :edit, :destroy]
  # the assets route is reserved for files in /public !
  resources :assets, path: 'files', only: [:create, :destroy]

  get '/library' => 'library#index'

  get '/queue' => 'queue#index'
  get '/queue/reschedule' => 'queue#reschedule'
  get '/history' => 'history#index'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

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
