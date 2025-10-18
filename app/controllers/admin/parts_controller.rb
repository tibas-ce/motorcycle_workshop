# == Controller: Admin::PartsController
# Controlador responsável pela gestão das peças (Parts) dentro do painel administrativo.
# Permite ao administrador cadastrar, visualizar, editar e remover peças do sistema.
class Admin::PartsController < ApplicationController
  # Localiza a peça com base no ID antes de executar as ações definidas.
  before_action :set_part, only: [ :show, :edit, :update, :destroy ]

  # GET /admin/parts
  # Lista todas as peças cadastradas, ordenadas por categoria e nome.
  def index
    @parts = Part.order(:category, :name)
  end

  # GET /admin/parts/:id
  # Exibe os detalhes de uma peça específica e os modelos de moto associados a ela.
  def show
    @models = @part.motorcycle_models
  end

  # GET /admin/parts/new
  # Renderiza o formulário para criação de uma nova peça.
  def new
    @part = Part.new
  end

  # POST /admin/parts
  # Cria uma nova peça com base nos parâmetros enviados pelo formulário.
  def create
    @part = Part.new(part_params)

    if @part.save
      redirect_to admin_part_path(@part), notice: "Peça criada com sucesso!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    # @part já está definido pelo before_action :set_part
    # Rails automaticamente renderiza app/views/admin/parts/edit.html.erb
  end

  # PATCH/PUT /admin/parts/:id
  # Atualiza os dados de uma peça existente.
  def update
    if @part.update(part_params)
      redirect_to admin_part_path(@part), notice: "Peça atualizada com sucesso!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /admin/parts/:id
  # Remove uma peça do sistema.
  def destroy
    @part.destroy
    redirect_to admin_parts_url, notice: "Peça removida com sucesso!"
  end

  private

  # Localiza a peça com base no ID recebido.
  def set_part
    @part = Part.find(params[:id])
  end

  # Define os parâmetros permitidos para criação e atualização de peças.
  def part_params
    params.require(:part).permit(
      :name,
      :original_code,
      :price,
      :stock,
      :description,
      :category
      )
  end
end
