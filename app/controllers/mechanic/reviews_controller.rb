# == Controller: Mechanic::ReviewsController
# Controlador responsável pelo gerenciamento das revisões realizadas pelos mecânicos.
# Permite listar, criar, visualizar, editar e finalizar revisões associadas a agendamentos.
class Mechanic::ReviewsController < ApplicationController
  # Localiza a revisão antes das ações que precisam de um registro carregado.
  before_action :set_revisao, only: [ :show, :edit, :update, :finish ]

  # GET /mechanic/reviews
  # Lista as revisões do mecânico logado.
  # Separa as revisões em andamento e as concluídas (últimas 10).
  def index
    @reviews_in_progress = current_user.mechanic.reviews.em_andamento.includes(:motorcycle)
    @completed_reviews = current_user.mechanic.reviews.concluidas.order(completion_date: :desc).limit(10)
  end

  # GET /mechanic/reviews/:id
  # Exibe os detalhes de uma revisão específica.
  # Inclui as peças utilizadas e as disponíveis para o modelo da motocicleta.
  def show
    @review_parts = @review.review_parts.includes(:part)
    @available_parts = @review.motorcycle.motorcycle_model.part
  end

  # GET /mechanic/reviews/new?scheduling_id=:id
  # Cria uma nova revisão a partir de um agendamento.
  # Define automaticamente o mecânico, a motocicleta e o tipo de serviço.
  def new
    @schedulings = Scheduling.find(params[:scheduling_id])
    @review = @scheduling.build_revisao
    @review.mechanic = current_user.mechanic
    @review.motorcycle = @scheduling.motorcycle
    @review.service_type = @scheduling.service_type
  end

  # POST /mechanic/reviews
  # Salva a revisão criada a partir de um agendamento.
  # Atualiza o status do agendamento para “realizado”.
  def create
    @scheduling = Scheduling.find(params[:scheduling_id])
    @review = @scheduling.build_review(review_params)
    @review.mechanic = current_user.mechanic

    if @review.save
      @scheduling.update(status: "realizado")
      redirect_to mechanic_review_path(@review), notice: "Revisão iniciada!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    # @review já está definido pelo before_action :set_review
    # Rails automaticamente renderiza app/views/mechanic/reviews/edit.html.erb
  end

  # PATCH/PUT /mechanic/reviews/:id
  # Atualiza os dados de uma revisão, como observações e valores de mão de obra.
  def update
    if @review.update(review_params)
      redirect_to mechanic_review_path(@review), notice: "Revisão atualizada!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # PATCH /mechanic/reviews/:id/finish
  # Finaliza uma revisão, alterando seu status para “concluída”
  # e registrando a data de conclusão.
  def finish
    @review.finish
    redirect_to mechanic_reviews_path, notice: "Revisão finalizada!"
  end

  private

  # Localiza a revisão com base no ID informado e
  # garante que pertença ao mecânico logado.
  def set_review
    @review = Review.find(params[:id])
    redirect_to mechanic_reviews_path unless @review.mechanic == current_user.mechanic
  end

  # Define os parâmetros permitidos para criação e atualização de revisões.
  def review_params
    params.require(:review).permit(
      :start_date, :km_review,
      :status, :labor_value,
      :mechanic_observations,
      :internal_observations,
      :report
      )
  end
end
