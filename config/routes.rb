Rails.application.routes.draw do
  namespace :admin do
    resource :openbravo_settings
  end
end
