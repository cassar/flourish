Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check
  devise_for :users

  root to: ->(_env) { [200, { "content-type" => "text/plain" }, ["Flourish is being redesigned."]] }
end
