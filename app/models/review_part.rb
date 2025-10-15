# == Schema Information
# Model: ReviewPart
# Representa a relação entre uma revisão (Review) e uma peça (Part) utilizada nesse serviço.
# Cada registro guarda a quantidade e o preço unitário da peça aplicada, além de atualizar automaticamente o estoque e o valor total da revisão.
class ReviewPart < ApplicationRecord
  # Associação: a peça utilizada pertence a uma revisão específica.
  belongs_to :review
  # Associação: o registro está vinculado a uma peça do estoque.
  belongs_to :part

  # Validações de presença: garantem que os campos essenciais estejam preenchidos.
  validates :quantity, :unit_price, presence: true
  # Validação: a quantidade deve ser maior que zero.
  validates :quantity, numericality: { greater_than: 0 }
  # Validação: o preço unitário não pode ser negativo.
  validates :unit_price, numericality: { greater_than_or_equal_to: 0 }
  # Validação: impede que a mesma peça seja adicionada mais de uma vez na mesma revisão.
  validates :part_id, uniqueness: { scope: :review_id }

  # Callback: antes de salvar, define o preço unitário caso não tenha sido informado.
  before_save :calculate_subtotal
  # Callbacks: após salvar, atualiza o estoque da peça e o valor total da revisão.
  after_save :update_stock
  after_save :update_revision_value

  # Calcula o valor total referente a essa peça (quantidade * preço unitário).
  def subtotal
    quantity * unit_price
  end

  private

  # Define automaticamente o preço unitário com base no valor atual da peça, caso o campo esteja vazio.
  def calculate_subtotal
    self.unit_price = part.price if unit_price.nil?
  end

  # Atualiza o estoque da peça, subtraindo a quantidade utilizada na revisão.
  def update_stock
    part.update(stock: part.stock - quantity) if quantity_changed?
  end

  # Atualiza o valor total da revisão após salvar a peça utilizada.
  def update_revision_value
    review.calculate_total_value
    review.save
  end
end
