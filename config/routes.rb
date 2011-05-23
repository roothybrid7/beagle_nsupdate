BeagleNsupdate::Application.routes.draw do
  get "dashboard/index"

  resources :groups do
    resources :zones
  end

  resources :zones do
    resource :group
  end

  root :to => "dashboard#index"
end
