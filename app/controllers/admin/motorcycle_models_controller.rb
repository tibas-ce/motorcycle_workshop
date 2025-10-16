# == Controller: Admin::MotorcycleModelsController
# Controlador responsável pela administração dos modelos de motocicletas.
# Permite que administradores cadastrem, visualizem, editem e removam modelos.
# Também possibilita o gerenciamento das peças associadas a cada modelo.
class Admin::MotorcycleModelsController < ApplicationController
  # Localiza o modelo de moto antes de ações que precisam de um registro carregado.
  before_action :set_motorcycle_model, only: [ :show, :edit, :update, :destroy ]

  # GET /admin/motorcycle_models
  # Lista todos os modelos de motocicletas cadastrados no sistema.
  def index
    @motorcycle_models = MotorcycleModel.all
  end

  # GET /admin/motorcycle_models/:id
  # Exibe detalhes de um modelo específico.
  # Também carrega as peças disponíveis e as já vinculadas a esse modelo.
  def show
    @available_parts = Part.all
    @linked_parts = @motorcycle_model.parts
  end

  # GET /admin/motorcycle_models/new
  # Exibe o formulário de criação de um novo modelo de motocicleta.
  def new
    @motorcycle_model = MotorcycleModel.new
  end

  # POST /admin/motorcycle_models
  # Cria um novo modelo de motocicleta com os parâmetros informados.
  def create
    @motorcycle_model = MotorcycleModel.new(modelo_moto_params)

    if @motorcycle_model.save
      redirect_to admin_motorcycle_model_path(@motorcycle_model), notice: "Modelo cadastrado com sucesso!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    # @motorcycle_model já está definido pelo before_action :set_motorcycle_model
    # Rails automaticamente renderiza app/views/admin/motorcycle_models/edit.html.erb
  end

  # PATCH/PUT /admin/motorcycle_models/:id
  # Atualiza as informações de um modelo de motocicleta.
  def update
    if @motorcycle_model.update(motorcycle_model_params)
      redirect_to admin_motorcycle_model_path(@motorcycle_model), notice: "Modelo atualizado com sucesso!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /admin/motorcycle_models/:id
  # Remove um modelo de motocicleta do sistema.
  def destroy
    @motorcycle_model.destroy
    redirect_to admin_motorcycle_model_url, notice: "Modelo removido com sucesso!"
  end

  private

  # Localiza o modelo de motocicleta com base no ID informado na URL.
  def set_motorcycle_model
    @motorcycle_model = MotorcycleModel.find(params[:id])
  end

  # Define os parâmetros permitidos para criação/edição de modelos de moto.
  # Isso garante segurança e evita o Mass Assignment.
  def motorcycle_model_params
    params.require(:motorcycle_model).permit(
      :name,
      :displacement,
      :start_production_year,
      :end_production_year,
      :description,
      :warranty_months,
      :warranty_km
      )
  end
end
