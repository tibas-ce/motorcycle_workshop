# == Controller: MotorcyclesController
# Controlador responsável por gerenciar as motocicletas de um usuário.
# Permite operações CRUD (Create, Read, Update, Delete) para que o cliente cadastre, visualize, edite e remova suas motos do sistema.
class MotorcyclesController < ApplicationController
  # Exige que o usuário esteja autenticado para acessar qualquer ação.
  before_action :authenticate_user!
  # Localiza a moto específica antes de ações que precisam de um registro carregado.
  # Isso evita repetição de código e garante que o usuário só acesse suas próprias motos.
  before_action :set_motorcycle, only: [ :show, :edit, :update, :destroy ]

  # GET /motorcycles
  # Lista todas as motos pertencentes ao usuário atual.
  # Inclui o modelo da moto para evitar consultas N+1 (melhorando a performance).
  def index
    @motorcycles = current_user.motorcycles.includes(:motorcycle_model)
  end

  # GET /motorcycles/:id
  # Exibe detalhes de uma moto específica, suas revisões e agendamentos.
  def show
    @schendulings = @motorcycle.schendulings.order(scheduled_time_date: :desc)
    @reviews = @motorcycle.reviews.includes(:mechanic).order(start_date: :desc)
  end

  # GET /motorcycles/new
  # Exibe o formulário para cadastrar uma nova moto.
  def new
    @motorcycle = current_user.motorcycles.build
    @motorcycle_models = MotorcycleModel.all
  end

  # POST /motorcycles
  # Cria uma nova moto associada ao usuário logado.
  def create
    @motorcycle = current_user.motorcycles.build(motorcycle_params)

    if @motorcycle.save
      redirect_to @motorcycle, notice: "Moto cadastrada com sucesso!"
    else
      @motorcycle_models = MotorcycleModel.all
      render :new, status: :unprocessable_entity
    end
  end

  # GET /motorcycles/:id/edit
  # Exibe o formulário para edição dos dados da moto.
  def edit
    @motorcycle_models = MotorcycleModel.all
  end

  # PATCH/PUT /motorcycles/:id
  # Atualiza as informações de uma moto existente.
  def update
    if @motorcycle.update(motorcycle_params)
      redirect_to @motorcycle, notice: "Moto atualizada com sucesso!"
    else
      @motorcycle_models = MotorcycleModel.all
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /motorcycles/:id
  # Remove uma moto do sistema.
  def destroy
    @motorcycle.destroy
    redirect_to motorcycles_url, notice: "Moto removida com sucesso!"
  end

  private

  # Localiza a moto pertencente ao usuário logado.
  # Caso o ID não pertença ao usuário, o Rails lança um erro ActiveRecord::RecordNotFound, o que impede acesso indevido a registros de outros usuários.
  def set_motorcycle
    @motorcycle = current_user.motorcycles.find(params[:id])
  end

  # Define os parâmetros permitidos no formulário.
  # Isso evita o Mass Assignment e garante segurança no cadastro/edição.
  def motorcycle_params
    params.require(:motorcycle).permit(
      :motorcycle_model_id,
      :license_plate,
      :chassis,
      :year_of_manufacture,
      :color,
      :current_km,
      :purchase_date,
      :invoice_number
      )
  end
end
