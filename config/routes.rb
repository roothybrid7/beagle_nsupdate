BeagleNsupdate::Application.routes.draw do
  get "dashboard/index"

  resources :groups do
    resources :zones
  end

  resources :zones do
    resource :group
    get :all_records, :on => :member
  end

  match 'zones/:id/bulk_delete_records' => 'zones#bulk_delete_records', :via => :delete
  match 'zones/:id/bulk_add_records' => 'zones#bulk_add_records', :via => :post

  root :to => "dashboard#index"

#  match ':controller(/:action(/:id(.:format)))'
end
