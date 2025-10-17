# == Controller: SchedulingsController
# Controlador responsável por gerenciar os agendamentos de serviços realizados pelos clientes.
# Permite listar, visualizar, criar e cancelar agendamentos vinculados às motocicletas do usuário logado.
class SchedulingsController < ApplicationController
  # Garante que o usuário esteja autenticado antes de acessar qualquer ação.
  before_action :authenticate_user!
  # Localiza o agendamento com base no ID antes de ações que o utilizam.
  before_action :set_scheduling, only: [ :show, :destroy ]

  # GET /schedulings
  # Lista todos os agendamentos do usuário atual, incluindo informações sobre a motocicleta.
  # Os registros são exibidos em ordem decrescente de data agendada.
  def index
    @schedulings = current_user.schedulings.includes(:motorcycle).order(scheduled_time_date: :desc)
  end

  # GET /schedulings/:id
  # Exibe detalhes de um agendamento específico.
  # Inclui uma verificação de autorização para garantir que o agendamento pertença ao usuário logado.
  def show
    authorize_user!(@scheduling.user)
  end

  # GET /motorcycles/:motorcycle_id/schedulings/new
  # Exibe o formulário para criar um novo agendamento vinculado a uma motocicleta específica.
  def new
    @motorcycle = current_user.motorcycles.find(params[:motorcycle_id])
    @scheduling = @motorcycle.shendulings.build
    @service_type = @motorcycle.allowed_revision_types
  end

  # POST /schedulings
  # Cria um novo agendamento de serviço para a motocicleta selecionada.
  # Associa automaticamente o agendamento ao usuário atual.
  def create
    @motorcycle = current_user.motorcycles.find(params[:scheduling][:motorcycle_id])
    @scheduling = @motorcycle.shendulings.build(shenduling_params)
    @scheduling.user = current_user

    if @scheduling.save
      redirect_to @scheduling, notice: "Agendamento realizado com sucesso!"
    else
      @service_type = @motorcycle.allowed_revision_types
      render :new, status: :unprocessable_entity
    end
  end

  # DELETE /schedulings/:id
  # Cancela um agendamento existente, alterando seu status para "cancelado".
  def destroy
    authorize_user!(@scheduling.user)
    @scheduling.update(status: "cancelado")
    redirect_to shendulings_url, notice: "Agendamento cancelado."
  end

  private

  # Localiza o agendamento com base no ID informado na URL.
  def set_scheduling
    @agendamento = Scheduling.find(params[:id])
  end

  # Define os parâmetros permitidos para criação/edição de agendamentos.
  def scheduling_params
    params.require(:scheduling).permit(
      :scheduled_time_date,
      :service_type,
      :current_scheduling_km,
      :client_observations
      )
  end

  # Verifica se o agendamento pertence ao usuário logado.
  # Caso contrário, redireciona para a página inicial com alerta de acesso negado.
  def authorize_user!(user)
    redirect_to root_path, alert: "Acesso negado" unless current_user == user
  end
end
