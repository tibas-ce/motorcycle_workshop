# == Schema Information
# Model: Scheduling
# Representa um agendamento de serviço para uma motocicleta.
# Cada agendamento pertence a uma moto e a um usuário (cliente ou mecânico responsável).
# Também pode estar associado a uma avaliação (review) após o serviço.
class Scheduling < ApplicationRecord
  # Associação: o agendamento pertence a uma motocicleta específica.
  belongs_to :motorcycle
  # Associação: o agendamento pertence a um usuário, o cliente que solicitou o serviço.
  belongs_to :user
  # Associação: um agendamento pode ter uma avaliação associada após sua realização.
  # O uso de `dependent: :nullify` faz com que, se o agendamento for apagado, o campo `scheduling_id` em `reviews` seja definido como nulo, preservando o histórico.
  has_one :review, dependent: :nullify

  # Validações de presença: garantem que o agendamento tenha data/hora, tipo e status definidos.
  validates :scheduled_time_date, :type, :status, presence: true
  # Validação: restringe o tipo de serviço aos valores definidos.
  # "garantia" → revisão coberta pela garantia da moto
  # "normal" → revisão comum
  validates :service_type, inclusion: { in: %w[garantia normal] }
  # Validação: restringe o status aos estados permitidos.
  # Permite rastrear o andamento do agendamento.
  validates :status, inclusion: { in: %w[pendente confirmado cancelado realizado] }

  # Validações personalizadas
  validate :validate_warranty_type
  validate :future_date

  # Escopos: facilitam consultas frequentes e deixam o código dos controllers mais limpo.
  scope :pending, -> { where(status: "pendente") }
  scope :confirmed, -> { where(status: "confirmado") }
  scope :futures, -> { where("scheduled_time_date >= ?", Time.current).order(scheduled_time_date: :asc) }

  private

  # Validação customizada:
  # Impede o agendamento do tipo "garantia" caso a motocicleta não esteja mais em garantia.
  def validate_warranty_type
    if service_type == "garantia" && !motorcycle.under_warranty?
      errors.add(:service_type, "A moto não está mais em garantia")
    end
  end

  # Validação customizada:
  # Garante que a data/hora agendada seja futura.
  def future_date
    if scheduled_time_date.present? && scheduled_time_date < Time.current
      errors.add(:scheduled_time_date, "deve ser no futuro")
    end
  end
end
