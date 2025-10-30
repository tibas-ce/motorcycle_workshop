# == Controller: Mechanic::SchedulingsController
# Controlador responsável por gerenciar os agendamentos visualizados e administrados pelo mecânico. Permite listar, visualizar e confirmar agendamentos de clientes.
class Mechanic::SchendulingsController < ApplicationController
  # GET /mechanic/schedulings
  # Lista os agendamentos, aplicando filtros conforme o parâmetro informado.
  def index
    # Carrega os agendamentos com informações do cliente e do modelo da motocicleta
    @schedulings = Scheduling.includes(:user, motorcycle: :motorcycle_model)
                               .order(scheduled_time_date: :asc)

    # Aplica o filtro de exibição conforme o parâmetro recebido
    case params[:filtro]
    when "hoje"
      # Exibe apenas os agendamentos marcados para o dia atual
      @schedulings = @schedulings.where(
        scheduled_time_date: Date.today.beginning_of_day..Date.today.end_of_day
      )
    when "semana"
      # Exibe os agendamentos da semana atual
      @schedulings = @schedulings.where(
        scheduled_time_date: Date.today.beginning_of_week..Date.today.end_of_week
      )
    when "pendentes"
      # Exibe apenas os agendamentos pendentes
      @schedulings = @schedulings.where(status: "pendente")
    else
      # Exibe agendamentos futuros com status pendente ou confirmado
      @schedulings = @schedulings.where(status: [ "pendente", "confirmado" ])
                                   .where("scheduled_time_date >= ?", Time.current)
    end
  end

  # GET /mechanic/schedulings/:id
  # Exibe os detalhes de um agendamento específico.
  def show
    @scheduling = Scheduling.find(params[:id])
  end

  # PATCH /mechanic/schedulings/:id/confirmar
  # Atualiza o status do agendamento para “confirmado”.
  def confirm
    @scheduling = Scheduling.find(params[:id])

    if @scheduling.update(status: "confirmado")
      redirect_to mechanic_scheduling_path(@scheduling), notice: "Agendamento confirmado!"
    else
      redirect_to mechanic_scheduling_path(@scheduling), alert: "Erro ao confirmar agendamento."
    end
  end
end
