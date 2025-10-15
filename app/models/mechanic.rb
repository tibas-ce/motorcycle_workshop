# == Schema Information
# Model: Mechanic
# Responsável por representar os mecânicos da oficina. Cada mecânico está associado a um usuário (User) e pode receber avaliações (Reviews).
class Mechanic < ApplicationRecord
  # Associação: cada mecânico pertence a um usuário.
  # Isso permite acessar dados de login e informações pessoais(como nome, email e telefone) através do relacionamento.
  belongs_to :user
  # Associação: um mecânico pode ter várias avaliações. As reviews podem representar feedbacks de clientes sobre o serviço prestado.
  has_many :reviews

  # Validação: garante que todo mecânico tenha um registro profissional único. O campo `professional_registration` é obrigatório e não pode se repetir no banco de dados.
  validates :professional_registration, presence: true, uniqueness: true

  # Escopo: retorna apenas os mecânicos com status ativo (ativo: true).
  # Útil para filtrar resultados em consultas sem repetir lógica.
  scope :ativo, -> { where(ativo: true) }

  # Delegação: permite acessar atributos do usuário diretamente pelo mecânico.
  # Exemplo: mechanic.name em vez de mechanic.user.name
  # Isso melhora a legibilidade e simplifica o código nas views e controllers.
  delegate :name, :email, :phone_number, to: :user
end
