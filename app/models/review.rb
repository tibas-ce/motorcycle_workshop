# == Schema Information
# Model: Review
# Representa uma revisão/serviço realizado em uma motocicleta.
# Pode estar associado a um agendamento (Scheduling), conter várias peças usadas e registrar o valor total do serviço (mão de obra + peças).
class Review < ApplicationRecord
  # Associação: A revisão pode estar vinculada a um agendamento específico.
  # O uso de `optional: true` permite criar revisões independentes.
  belongs_to :scheduling, optional: true
  # Associação: Cada revisão pertence a uma motocicleta.
  belongs_to :motorcycle
  # Associação: Cada revisão é executada por um mecânico.
  belongs_to :mechanic
  # Associação many-to-many entre Review e Part, via tabela intermediária ReviewPart.
  has_many :review_parts, dependent: :destroy
  has_many :parts, through: :review_parts

  # Valida a presença dos principais campos.
  validates :start_date, :km_review, :service_type, :status, presence: true
  # Garante que o tipo de serviço e o status tenham apenas valores válidos.
  validates :service_type, inclusion: { in: %w[garantia normal] }
  validates :status, inclusion: { in: %w[em_andamento concluida aguardando_peca] }
  # O quilômetro da revisão deve ser maior que zero.
  validates :km_review, numericality: { greater_than: 0 }

  # Antes de salvar, calcula o valor total da revisão.
  before_save :calculate_total_value

  # Escopo para buscar revisões concluídas.
  scope :completed, -> { where(status: "concluida") }
  # Escopo para buscar revisões em andamento.
  scope :in_progress, -> { where(status: "em_andamento") }

  # Método de instância: Calcula o valor total da revisão somando o valor da mão de obra com o total das peças associadas.
  def calculate_total_value
    total_parts = review_parts.sum(&:subtotal)
    self.total_value = labor_value + total_parts
  end

  # Método de instância: Marca a revisão como concluída e atualiza o agendamento (se existir).
  def finish
    update(status: "concluida", completion_date: Time.current)
    scheduling&.update(status: "realizado")
  end
end
