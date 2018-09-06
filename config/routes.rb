Rails.application.routes.draw do
  devise_for :admin_usuarios, ActiveAdmin::Devise.config
  Precompile.ignore { ActiveAdmin.routes(self) }
  root to: "admin/dashboard#index"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  #get 'principal/index'
  #root 'principal#index'
end
