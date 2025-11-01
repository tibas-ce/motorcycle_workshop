# == Controller: Mechanic::ReviewsController
# Controlador responsável pelo gerenciamento das revisões realizadas pelos mecânicos.
# Permite listar, criar, visualizar, editar e finalizar revisões associadas a agendamentos.
class Mechanic::ReviewsController < ApplicationController
  # Localiza a revisão antes das ações que precisam de um registro carregado.
  before_action :set_review, only: [ :show, :edit, :update, :finish ]

  # GET /mechanic/reviews
  # Lista as revisões do mecânico logado.
  # Permite filtrar por status: em andamento, concluída, aguardando peça ou todas.
  # As revisões em andamento são separadas das concluídas para facilitar a visualização.
  def index
    mechanic = current_user.mechanic

    case params[:filtro]
    when "concluida"
      @completed_reviews = mechanic.reviews.where(status: "concluida")
                                      .order(completion_date: :desc)
    when "aguardando_peca"
      @completed_reviews = mechanic.reviews.where(status: "aguardando_peca")
                                      .order(start_date: :desc)
    when "todas"
      @completed_reviews = mechanic.reviews.order(start_date: :desc)
    else # em_andamento ou sem filtro
      @reviews_in_progress = mechanic.reviews.where(status: [ "em_andamento", "aguardando_peca" ])
                                       .order(start_date: :desc)
      @completed_reviews = []
    end
  end

  # GET /mechanic/reviews/:id
  # Exibe os detalhes de uma revisão específica.
  # Carrega as peças já associadas e as peças disponíveis em estoque.
  def show
    @review_parts = @review.review_parts.includes(:part)
    @available_parts = Part.where("stock > 0").order(:name)
  end

  # GET /mechanic/reviews/new?scheduling_id=:id
  # Cria uma nova revisão a partir de um agendamento.
  # Define automaticamente o mecânico, a motocicleta e o tipo de serviço.
  # Caso o agendamento não seja encontrado, redireciona de volta à lista de agendamentos.
  def new
    if params[:scheduling_id].present?
      @schedulings = Scheduling.find(params[:scheduling_id])
      @review = @scheduling.build_review
      @review.mechanic = current_user.mechanic
      @review.motorcycle = @scheduling.motorcycle
      @review.service_type = @scheduling.service_type
      @review.status = "em_andamento"
    else
      redirect_to mechanic_schedulings_path, alert: "Selecione um agendamento primeiro"
    end
  end

  # POST /mechanic/reviews
  # Cria e salva uma nova revisão com base em um agendamento selecionado.
  # Define os vínculos de mecânico e motocicleta automaticamente.
  # Após salvar, atualiza o status do agendamento para “realizado”.
  def create
    @scheduling = Scheduling.find(params[:scheduling_id]) if params[:scheduling_id].present?

    if @scheduling
      @review = @scheduling.build_revisao(revisao_params)
      @review.mechanic = current_user.mechanic
      @review.motorcycle = @scheduling.motorcycle
      @review.service_type = @scheduling.service_type
    else
      @review = Review.new(review_params)
      @review.mechanic = current_user.mechanic
    end

    @review.status = "em_andamento"

    if @review.save
      @scheduling.update(status: "realizado")
      redirect_to mechanic_review_path(@review), notice: "Revisão iniciada!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  # GET /mechanic/reviews/:id/edit
  # Exibe o formulário de edição da revisão.
  # Impede a edição de revisões já finalizadas.
  def edit
    redirect_to mechanic_review_path(@review), alert: "Revisão já finalizada" if @review.status == "concluida"
  end

  # PATCH/PUT /mechanic/reviews/:id
  # Atualiza os dados de uma revisão (ex: observações, status, valor de mão de obra).
  # Exibe mensagem de sucesso ou renderiza o formulário novamente em caso de erro.
  def update
    if @review.update(review_params)
      redirect_to mechanic_review_path(@review), notice: "Revisão atualizada!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # PATCH /mechanic/reviews/:id/finish
  # Finaliza uma revisão, alterando seu status para “concluída” e registrando a data de conclusão.
  # Caso a revisão já tenha sido finalizada, exibe um alerta e retorna à página da revisão.
  def finish
    if @review.status == "concluida"
      redirect_to mechanic_review_path(@review), alert: "Revisão já foi finalizada"
      return
    end

    @review.finish
    redirect_to mechanic_reviews_path, notice: "Revisão finalizada!"
  end

  private

  # == Callback: set_review
  # Localiza a revisão com base no ID e verifica se pertence ao mecânico logado.
  # Em caso de erro ou acesso indevido, redireciona com mensagem de alerta.
  def set_review
    @review = current_user.mechanic.reviews.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to mechanic_reviews_path, alert: "Revisão não encontrada"
  end

  # Strong Parameters
  # Define os parâmetros permitidos para criação e atualização de revisões.
  def review_params
    params.require(:review).permit(
      :motorcycle_id,
      :start_date, :km_review,
      :status, :labor_value,
      :mechanic_observations,
      :internal_observations,
      :report
      )
  end
end
