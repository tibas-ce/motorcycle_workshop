# == Controller: Mechanic::BaseController
# Controlador base para todas as seções do painel do mecânico.
# Garante que apenas usuários autenticados e com o papel de mecânico
# possam acessar as rotas dentro do namespace `mechanic`.
class Mechanic::BaseController < ApplicationController
  # Exige que o usuário esteja autenticado antes de acessar qualquer página do painel do mecânico.
  before_action :authenticate_user!
  # Garante que apenas usuários com papel de mecânico tenham acesso.
  # Caso contrário, são redirecionados para a página inicial com uma mensagem de alerta, comportamento definido no método `require_mechanic` do `ApplicationController`.
  before_action :require_mechanic

  # Define o layout padrão utilizado nas views do painel do mecânico.
  # O arquivo correspondente deve estar localizado em:
  # `app/views/layouts/mechanic.html.erb`
  layout "mechanic"
end
