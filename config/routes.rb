Rails.application.routes.draw do
  resources :executors, only: %i[index show], param: :language
  post "executors/:language", to: "executors#execute", as: "execute_executor"
end
