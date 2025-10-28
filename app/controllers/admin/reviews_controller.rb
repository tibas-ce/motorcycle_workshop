# == Controller: Admin::ReviewsController
# Controlador responsável pela gestão das revisões (Reviews) dentro do painel administrativo.
# Permite ao administrador listar todas as revisões, filtrar por status e visualizar os detalhes de cada revisão.
class Admin::ReviewsController < Admin::BaseController
  # GET /admin/reviews
  # Lista todas as revisões, incluindo informações da motocicleta, modelo e usuário, assim como do mecânico responsável. Ordena por data de início em ordem decrescente.
  # Permite filtrar por status se o parâmetro `status` estiver presente.
  def index
    @reviews = Review
      .includes(motorcycle: [ :motorcycle_model, :user ], mechanic: :user)
      .order(start_date: :desc)

    if params[:status].present?
      @reviews = @reviews.where(status: params[:status])
    end
  end

  # GET /admin/reviews/:id
  # Exibe os detalhes de uma revisão específica, incluindo informações do cliente, motocicleta, modelo, mecânico e status da revisão.
  def show
    @review = Review.find(params[:id])
  end
end
