# == Controller: Admin::ModelPartsController
# Responsável por gerenciar a associação entre modelos de motocicletas (`MotorcycleModel`) e peças (`Part`) dentro do painel administrativo.
# Permite que o administrador vincule ou desvincule peças específicas a um modelo de moto.
class Admin::ModelPartsController < Admin::BaseController
  # Antes de qualquer ação, busca o modelo de motocicleta ao qual as peças serão associadas.
  before_action :set_motorcycle_model

  # POST /admin/motorcycle_model/:motorcycle_model_id/model_parts
  # Cria a associação entre uma peça e um modelo de motocicleta.
  # Caso o vínculo seja salvo com sucesso, redireciona de volta à página do modelo.
  # Caso contrário, exibe uma mensagem de erro.
  def create
    @model_part = @motorcycle_model.model_parts.build(model_part_params)

    if @model_part.save
      redirect_to admin_motorcycle_model_path(@motorcycle_model), notice: "Peça vinculada ao modelo!"
    else
      redirect_to admin_motorcycle_model_path(@motorcycle_model), alert: "Erro ao vincular peça"
    end
  end

  # DELETE /admin/motorcycle_model/:motorcycle_model_id/model_parts/:id
  # Remove a associação entre uma peça e o modelo de motocicleta.
  # A peça em si não é excluída, apenas o vínculo (registro na tabela `model_parts`).
  def destroy
    @model_part = ModelPart.find(params[:id])
    @model_part.destroy
    redirect_to admin_motorcycle_model_path(@motorcycle_model), notice: "Peça desvinculada!"
  end

  private

  # Localiza o modelo de motocicleta com base no parâmetro recebido na rota.
  # Essa informação é necessária para criar ou remover vínculos de peças.
  def set_motorcycle_model
    @motorcycle_model = MotorcycleModel.find(params[:motorcycle_model_id])
  end

  # Define e restringe os parâmetros permitidos para a criação do vínculo entre modelo e peça:
  # - part_id → identifica qual peça está sendo associada
  # - mandatory_review → indica se a peça é obrigatória em revisões de garantia
  # - km_replacement → define a quilometragem sugerida para substituição
  def model_part_params
    params.require(:model_part).permit(:part_id, :mandatory_review, :km_replacement)
  end
end
