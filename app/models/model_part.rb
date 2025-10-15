# == Schema Information
# Model: ModelPart
# Representa a relação entre um modelo de motocicleta e uma peça específica.
# Esta tabela de junção permite definir quais peças são compatíveis com quais modelos.
class ModelPart < ApplicationRecord
  # Associação: cada vínculo pertence a um modelo de motocicleta.
  # Isso indica que a peça listada é compatível com o modelo informado.
  belongs_to :motorcycle_model
  # Associação: cada vínculo pertence a uma peça específica.
  # Assim, é possível saber quais modelos utilizam determinada peça.
  belongs_to :part

  # Validação: impede que o mesmo par (modelo de motocicleta + peça) seja cadastrado mais de uma vez.
  # Isso evita duplicidade na tabela intermediária.
  validates :motorcycle_model_id, uniqueness: { scope: :part_id }
end
