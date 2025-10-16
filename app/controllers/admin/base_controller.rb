# == Controller: Admin::BaseController
# Controlador base para todas as seções administrativas do sistema.
# Garante que apenas usuários autenticados e com perfil de administrador possam acessar as rotas dentro do namespace `admin`.
class Admin::BaseController < ApplicationController
  # Exige que o usuário esteja autenticado antes de acessar qualquer página do painel admin.
  before_action :authenticate_user!
  # Garante que apenas usuários com papel de administrador tenham acesso.
  # Caso contrário, são redirecionados com mensagem de alerta definida em `ApplicationController`.
  before_action :require_admin

  # Define o layout padrão utilizado nas views do painel administrativo.
  # O arquivo correspondente deve estar localizado em: `app/views/layouts/admin.html.erb`
  layout "admin"
end
