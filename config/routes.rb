require "api_constraints"

Rails.application.routes.draw do
  mount SabisuRails::Engine => "/sabisu_rails"
  devise_for :users

  #API definition
  # namespace :api, defaults: { format: :json },
  #   constraints: { subdomain: 'api' },
  # path: '/' do
  #   scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do
  #     resources :users, only: [:show, :create, :update, :destroy]
  #     resources :sessions, only: [:create, :destroy]
  #     resources :products, only: [:show, :index, :create]
  #   end
  # end


  namespace :api, defaults: { format: :json },
    constraints: { subdomain: 'api' },
  path: '/' do
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do
      resources :users, only: [:show, :index, :create, :update, :destroy] do
        resources :products, only: [:create, :update, :destroy]
      end
      resources :sessions, only: [:create, :destroy]
      resources :products, only: [:show, :index]
    end
  end
end
