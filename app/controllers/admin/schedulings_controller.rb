# == Controller: Admin::SchedulingsController
# Controlador responsável pela gestão dos agendamentos dentro do painel administrativo.
# Permite ao administrador visualizar a lista de agendamentos e os detalhes de cada agendamento.
class Admin::SchedulingsController < Admin::BaseController
  # GET /admin/schedulings
  # Lista todos os agendamentos, incluindo informações do usuário e da motocicleta.
  # Permite filtrar por status se o parâmetro `status` estiver presente.
  def index
    @schedulings = Scheduling
      .includes(:user, motorcycle: :motorcycle_model)
      .order(scheduled_time_date: :desc)

    if params[:status].present?
      @schedulings = @schedulings.where(status: params[:status])
    end
  end

  # GET /admin/schedulings/:id
  # Exibe os detalhes de um agendamento específico.
  def show
    @scheduling = Scheduling.find(params[:id])
  end
end
