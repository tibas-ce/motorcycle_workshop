# == Schema Information
# Model: Part
# Representa uma peça de motocicleta no estoque da oficina.
# Cada peça pode estar associada a vários modelos de moto e também a avaliações (reviews) específicas.
class Part < ApplicationRecord
  # Associação: conecta a peça à tabela intermediária ModelPart, que define quais modelos de motocicleta são compatíveis com esta peça.
  has_many :model_parts
  # Associação: permite acessar os modelos de motocicleta que utilizam esta peça através do relacionamento com ModelPart.
  has_many :motorcycle_models, through: :model_parts
  # Associação: conecta a peça às suas avaliações (reviews) através da tabela intermediária ReviewPart.
  # Isso permite que clientes ou mecânicos avaliem peças específicas.
  has_many :review_parts
  has_many :reviews, through: :review_parts

  # Validação: garante que nome, código original e preço estejam sempre preenchidos.
  validates :name, :original_code, :price, presence: true
  # Validação: assegura que o código original da peça seja único no sistema,
  # evitando cadastros duplicados.
  validates :original_code, uniqueness: true
  # Validação: garante que o preço da peça seja numérico e maior que zero.
  validates :price, numericality: { greater_than: 0 }
  # Validação: impede que o estoque seja negativo.
  validates :stock, numericality: { greater_than_or_equal_to: 0 }

  # Método de instância: verifica se a peça está disponível no estoque.
  # Retorna true se o estoque for maior que zero, caso contrário, false.
  # Exemplo:
  #   part.disponivel? => true ou false
  def disponivel?
    stock > 0
  end
end
