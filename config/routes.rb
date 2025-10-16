Rails.application.routes.draw do
  # Rotas geradas automaticamente pelo Devise para autenticação de usuários
  devise_for :users

  # get "up" => "rails/health#show", as: :rails_health_check
  # root "posts#index"

  # Define a página inicial do sistema (HomeController#index)
  root "home#index"

  # Rotas para Clientes
  # As rotas de clientes estão focadas no gerenciamento de motocicletas e no agendamento de serviços.
  resources :motorcycles do
    # Rotas aninhadas: permitem criar agendamentos dentro do contexto de uma moto específica.
    resources :scheduling, only: [ :new, :create ]
  end
  # Rotas adicionais para visualizar, listar e cancelar agendamentos.
  resources :scheduling, only: [ :index, :show, :destroy ] do
    # Rota customizada: PATCH /scheduling/:id/cancelar
    # Permite cancelar um agendamento já criado.
    member do
      patch :cancelar
    end
  end

  # Rotas para Mecânico
  # As rotas dentro do namespace "mechanic" geram caminhos e controladores com o prefixo mechanic/, como mechanic/scheduling#index.
  namespace :mechanic do
    # Painel principal do mecânico
    get "dashboard", to: "dashboard#index"
    # Listagem e visualização de agendamentos atribuídos ao mecânico.
    resources :scheduling, only: [ :index, :show ] do
      # PATCH /mechanic/scheduling/:id/confirmar
      # Permite ao mecânico confirmar o agendamento de um serviço.
      member do
        patch :confirmar
      end
    end
    # Controle das revisões realizadas pelo mecânico.
    resources :reviews do
      # Permite adicionar ou remover peças utilizadas durante uma revisão.
      resources :review_parts, only: [ :create, :destroy ]
      # PATCH /mechanic/reviews/:id/finalizar
      # Utilizado para marcar uma revisão como concluída.
      member do
        patch :finalizar
      end
    end
  end

  # Rotas para Admin
  # O namespace "admin" organiza rotas específicas de administração, geralmente com permissões exclusivas.
  namespace :admin do
    # Painel principal do administrador.
    get "dashboard", to: "dashboard#index"
    # Gerenciamento dos modelos de motocicletas.
    resources :motorcycle_model do
      # Permite adicionar ou remover peças relacionadas a um modelo.
      resources :model_parts, only: [ :create, :destroy ]
    end
    # CRUD completo para peças e mecânicos.
    resources :parts
    resources :mechanics
    # Gerenciamento de usuários: o admin pode listar, visualizar e editar perfis.
    resources :users, only: [ :index, :show, :edit, :update ]
    # Visualização de agendamentos e revisões para fins de monitoramento.
    resources :schedulings, only: [ :index, :show ]
    resources :reviews, only: [ :index, :show ]
  end
end
