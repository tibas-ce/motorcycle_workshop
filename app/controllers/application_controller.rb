# == Controller: ApplicationController
# Controlador base da aplicação, do qual todos os outros herdam.
# Define comportamentos e permissões globais, além de integrar configurações do Devise.
class ApplicationController < ActionController::Base
  # allow_browser versions: :modern

  # Filtro executado antes de qualquer ação do Devise.
  # Permite adicionar campos personalizados aos formulários de cadastro e edição de conta.
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  # O Devise, por padrão, só permite os campos essenciais (e-mail, senha, etc.).
  # Este método adiciona campos extras ao cadastro e atualização de usuários.
  # Campos adicionais permitidos:
  # - name: nome completo do usuário
  # - phone_number: telefone de contato
  # - address: endereço residencial
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :name, :phone_number, :address, :role ])
    devise_parameter_sanitizer.permit(:account_update, keys: [ :name, :phone_number, :address, :role ])
  end

  # Garante que apenas usuários administradores acessem determinadas áreas do sistema.
  # Caso contrário, redireciona para a página inicial com uma mensagem de alerta.
  def require_admin
    unless current_user&.admin?
      redirect_to root_path, alert: "Acesso negado"
    end
  end

  # Garante que apenas usuários com perfil de mecânico acessem áreas específicas.
  # Caso o usuário não seja um mecânico autenticado, é redirecionado para a home.
  def require_mecanico
    unless current_user&.mecanico?
      redirect_to root_path, alert: "Acesso negado"
    end
  end
end
