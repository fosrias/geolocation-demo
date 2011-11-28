GeolocationDemo::Application.routes.draw do
  resources :tweets, :only => :index do
    collection { post :search, :action => :coordinate_search }
  end

  root :to => "tweets#index"
end
