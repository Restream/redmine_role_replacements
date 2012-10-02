ActionController::Routing::Routes.draw do |map|
  map.resources :projects do |project|
    project.resources :role_replacements, :only => [:index, :new, :create, :edit, :update, :destroy]
  end
end
