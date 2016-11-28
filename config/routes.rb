RedmineApp::Application.routes.draw do
  resources :projects do
    resources :role_replacements, only: [:index, :new, :create, :edit, :update, :destroy]
  end
end
