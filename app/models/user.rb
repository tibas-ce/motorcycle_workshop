class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  # Inclui os módulos do Devise que controlam autenticação e registro de usuários.
  # - :database_authenticatable → permite login via e-mail/senha armazenados no banco.
  # - :registerable → permite que usuários criem e editem suas contas.
  # - :recoverable → permite recuperação de senha via e-mail.
  # - :rememberable → permite que o login seja lembrado (cookies).
  # - :validatable → validações automáticas de e-mail e senha.
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Relacionamentos Active Record:
  # Um usuário pode ter várias motos e agendamentos (quando ele é cliente, por exemplo).
  # Se o usuário for deletado, suas motos e agendamentos também são apagados.
  has_many motorcycle, dependent: :destroy
  has_many scheduling, dependent: :destroy
  # Um usuário pode ter um mecânico associado (caso seja um usuário do tipo "mecânico").
  # O registro do mecânico é excluído se o usuário for removido.
  has_one mechanic, dependent: :destroy

  # Validações de presença — exige que o nome e o papel (role) sejam informados.
  validates :name, :role, presence: true
  # Validação de inclusão — garante que o valor de role seja um dos três permitidos: "cliente", "admin" ou "mecanico".
  validates :role, inclusion: { in: %w[cliente admin mecanico] }

  # Métodos auxiliares para verificar o tipo de usuário.
  # Retornam true/false conforme o papel (role) do usuário.
  def admin?
    role == "admin"
  end

  def cliente?
    role == "cliente"
  end

  def mecanico?
    role == "mecanico"
  end
end
