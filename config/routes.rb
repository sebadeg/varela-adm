Rails.application.routes.draw do
  devise_for :admin_usuarios, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  root to: "admin/dashboard#index"

  #get 'principal/index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  #root 'principal#index'
end
