Rails.application.routes.draw do
  resources :compute_resources do
    resources :image_upload
  end
end
