# == Schema Information
# Model: Motorcycle
# Representa uma motocicleta cadastrada no sistema.
# Cada motocicleta pertence a um usuário (proprietário) e a um modelo de moto específico.
# Também pode ter agendamentos de serviços (scheduling) e avaliações (reviews).
class Motorcycle < ApplicationRecord
  # Associação: cada motocicleta pertence a um usuário, que é o proprietário.
  belongs_to :user
  # Associação: cada motocicleta pertence a um modelo de moto, que define suas especificações, cilindrada e informações de garantia.
  belongs_to :motorcycle_model
  # Associação: uma motocicleta pode ter vários agendamentos de serviço.
  # O `dependent: :destroy` garante que, se a moto for excluída, todos os agendamentos relacionados também sejam removidos.
  has_many :schedulings, dependent: :destroy
  # Associação: uma motocicleta pode ter várias avaliações (reviews).
  # Ao excluir a moto, suas avaliações também são removidas.
  has_many :reviews, dependent: :destroy

  # Validação: garante que placa, chassi, ano de fabricação e data de compra sejam obrigatórios.
  validates :license_plate, :chassis, :year_of_manufacture, :purchase_date, presence: true
  # Validação: impede que existam duas motos com a mesma placa ou chassi.
  validates :license_plate, :chassis, uniqueness: true
  # Validação: impede que a quilometragem atual seja negativa.
  validates :current_km, numericality: { greater_than_or_equal_to: 0 }

  # Método de instância: verifica se a moto ainda está dentro da garantia.
  # A garantia é válida se o tempo e a quilometragem desde a compra estiverem dentro dos limites definidos no modelo da moto (motorcycle_model).
  # @return [Boolean] true se estiver dentro da garantia, false caso contrário.
  def under_warranty?
    return false unless purchase_date && motorcycle_model

    months_since_purchase = ((Date.today - purchase_date) / 30).to_i

    months_since_purchase <= motorcycle_model.warranty_months &&
    current_km <= motorcycle_model.warranty_km
  end

  # Método de instância: retorna uma mensagem informando o tempo e a quilometragem restantes da garantia, ou indica que a moto está fora de garantia.
  def info_guarantee
    if under_warranty?
      remaining_months = motorcycle_model.warranty_months - ((Date.today - purchase_date) / 30).to_i
      km_remaining = motorcycle_model.warranty_km - current_km
      "#{remaining_months} meses ou #{km_remaining} km restantes"
    else
      "Fora da garantia!"
    end
  end

  # Método de instância: define os tipos de revisão permitidos para a motocicleta.
  # Motos dentro da garantia podem ter revisões "garantia" e "normal".
  # Motos fora da garantia só podem ter revisões "normal".
  def allowed_revision_types
    under_warranty? ? [ "garantia", "normal" ] : [ "normal" ]
  end
end
