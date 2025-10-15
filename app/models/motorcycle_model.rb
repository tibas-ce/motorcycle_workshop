# == Schema Information
# Model: MotorcycleModel
# Representa um modelo de motocicleta cadastrado na oficina.
# Cada modelo pode estar associado a várias motocicletas específicas e às peças compatíveis através da relação com ModelPart.
class MotorcycleModel < ApplicationRecord
  # Associação: um modelo de motocicleta pode ter várias motocicletas cadastradas.
  # Exemplo: o modelo "Hunter 350" pode ter várias motos registradas na oficina.
  has_many :motorcycles
  # Associação: conecta o modelo às suas peças compatíveis através da tabela intermediária ModelPart.
  # O `dependent: :destroy` garante que, ao excluir um modelo, os vínculos com peças também sejam removidos.
  has_many :model_parts, dependent: :destroy
  has_many :parts, through: :model_parts

  # Validação: garante que o nome e a cilindrada do modelo sejam obrigatórios.
  # Exemplo: nome = "Hunter 350", displacement = "350cc".
  validates :name, :displacement, presence: true
  # Validação: assegura que os valores de garantia (em meses e quilômetros) sejam numéricos e maiores que zero.
  # Isso evita registros inválidos como garantia negativa ou nula.
  validates :warranty_months, :warranty_km, numericality: { greater_than: 0 }
end
