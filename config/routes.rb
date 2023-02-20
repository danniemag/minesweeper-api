Rails.application.routes.draw do
  devise_for :users,
             controllers: {
               sessions: 'users/sessions',
               registrations: 'users/registrations'
             }

  namespace 'api' do
    namespace 'v1' do
      resources :games, only: :create do
        member do
          post :play
          post :pause
          post :flag
        end
      end
    end
  end
end
