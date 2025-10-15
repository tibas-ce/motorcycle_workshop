class MotorcycleModel < ApplicationRecord
  has_many :motorcycles
  has_many :model_parts, dependent: :destroy
  has_many :parts, through: :model_parts

  validates :name, :displacement, presence: true
  validates :warranty_months, :warranty_km, numericality: { greater_than: 0 }
end
