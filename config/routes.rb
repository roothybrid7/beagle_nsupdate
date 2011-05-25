BeagleNsupdate::Application.routes.draw do
  get "dashboard/index"

  resources :groups do
    resources :zones
  end

  resources :zones do
    resource :group
    get :all_records, :on => :member
  end

  match 'zones/:id/delete_records' => 'zones#delete_records'

  root :to => "dashboard#index"

#  match ':controller(/:action(/:id(.:format)))'
end
