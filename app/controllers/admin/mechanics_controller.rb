# == Controller: Admin::MechanicsController
# Controlador responsável pela gestão dos mecânicos dentro do painel administrativo.
# Permite ao administrador cadastrar, visualizar, editar e remover mecânicos do sistema.
class Admin::MechanicsController < ApplicationController
  # Localiza o mecânico com base no ID antes de executar as ações definidas.
  before_action :set_mechanic, only: [ :show, :edit, :update, :destroy ]

  # GET /admin/mechanics
  # Lista todos os mecânicos cadastrados, ordenados por nome.
  def index
    @mechanics = Mechanic.includes(:user).order("users.name")
  end

  # GET /admin/mechanics/:id
  # Exibe os detalhes de um mecânico específico, incluindo histórico de revisões.
  def show
    @mechanic = Mechanic.find(params[:id])
  end

  # GET /admin/mechanics/new
  # Renderiza o formulário para cadastro de um novo mecânico.
  def new
    @mechanic = Mechanic.new
  end

  # POST /admin/mechanics
  # Cria um novo mecânico com base nos parâmetros enviados pelo formulário.
  # Também cria o usuário associado ao mecânico.
  def create
    ActiveRecord::Base.transaction do
      @user = User.new(
        name: params[:name],
        email: params[:email],
        password: params[:password],
        password_confirmation: params[:password],
        phone_number: params[:phone_number],
        role: "mecanico"
      )

      if @user.save
        @mechanic = @user.create_mechanic!(
          professional_registration: params[:professional_registration],
          specialty: params[:specialty],
          asset: params[:asset] == "1"
        )
        redirect_to admin_mechanic_path(@mechanic), notice: "Mecânico cadastrado com sucesso!"
      else
        render :new, status: :unprocessable_entity
      end
    end
  rescue ActiveRecord::RecordInvalid => e
    flash.now[:alert] = e.message
    render :new, status: :unprocessable_entity
  end

  # GET /admin/mechanics/:id/edit
  # Renderiza o formulário para edição dos dados de um mecânico existente.
  def edit
    # @mechanic já está definido pelo before_action :set_mechanic
  end

  # PATCH/PUT /admin/mechanics/:id
  # Atualiza os dados de um mecânico existente.
  # Também atualiza os dados do usuário associado.
  def update
    ActiveRecord::Base.transaction do
      @mechanic.user.update!(
        name: params[:name],
        phone_number: params[:phone_number]
      )

      if @mechanic.update(mechanic_params)
        redirect_to admin_mechanic_path(@mechanic), notice: "Mecânico atualizado com sucesso!"
      else
        render :edit, status: :unprocessable_entity
      end
    end
  end

  # DELETE /admin/mechanics/:id
  # Remove um mecânico do sistema, excluindo também o usuário associado.
  def destroy
    @mechanic.user.destroy
    redirect_to admin_mechanics_url, notice: "Mecânico removido com sucesso!"
  end

  private

  # Localiza o mecânico com base no ID recebido.
  def set_mechanic
    @mechanic = Mechanic.find(params[:id])
  end

  # Define os parâmetros permitidos para criação e atualização de mecânicos.
  def mechanic_params
    params.require(:mechanic).permit(
      :professional_registration,
      :specialty,
      :asset
    )
  end
end
