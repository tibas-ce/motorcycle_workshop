# == Controller: Mechanic::DashboardController
# Controller responsável por exibir o painel principal do mecânico (Dashboard)
# Mostra informações como revisões em andamento, concluídas, agendamentos do dia, estatísticas e ganhos mensais.
class Mechanic::DashboardController < ApplicationController
  # Ação principal do painel do mecânico
  def index
    # Obtém o registro do mecânico associado ao usuário logado
    mechanic = current_user.mechanic

    # Conta quantas revisões estão em andamento para o mecânico atual
    @reviews_in_progress = mechanic.reviews.where(status: "em_andamento").count
    # Conta quantas revisões foram concluídas
    @completed_reviews = mechanic.reviews.where(status: "concluida").count

    # Conta o número de agendamentos do dia com status pendente ou confirmado
    @schedulings_today = Scheduling.where(
      scheduled_time_date: Date.today.beginning_of_day..Date.today.end_of_day,
      status: [ "pendente", "confirmado" ]
    ).count

    # Soma o valor total das revisões iniciadas no mês atual
    @total_month = mechanic.reviews
      .where("data_inicio >= ?", Date.today.beginning_of_month)
      .sum(:total_value)

    # Busca os próximos 10 agendamentos futuros (pendentes ou confirmados)
    @next_schedulings = Scheduling
      .where("scheduled_time_date >= ?", Time.current)
      .where(status: [ "pendente", "confirmado" ])
      .order(scheduled_time_date: :asc)
      .limit(10)
      .includes(:user, motorcycle: :motorcycle_model)

    # Conta o total geral de revisões do mecânico
    @total_reviews = mechanic.reviews.count
    # Conta as revisões iniciadas no mês atual
    @reviews_month = mechanic.reviews
      .where("start_date >= ?", Date.today.beginning_of_month)
      .count
    # Calcula a média de valores das revisões (retorna 0 se não houver)
    @media_valor = mechanic.reviews.average(:total_value) || 0
  end
end
