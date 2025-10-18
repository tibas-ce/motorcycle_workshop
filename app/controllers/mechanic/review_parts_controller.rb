# == Controller: Mechanic::ReviewPartsController
# Controlador responsável por gerenciar as peças utilizadas em uma revisão.
# Permite adicionar e remover peças associadas a uma revisão realizada pelo mecânico.
class Mechanic::ReviewPartsController < Mechanic::BaseController
  # Carrega a revisão antes de criar ou remover peças.
  before_action :set_review

  # POST /mechanic/reviews/:review_id/review_parts
  # Adiciona uma nova peça à revisão, atualizando o subtotal.
  def create
    @review_part = @review.review_parts.build(review_part_params)

    if @review_part.save
      # Recalcula o subtotal da revisão após adicionar a peça
      @review.calculate_subtotal
      @review.save
      redirect_to mechanic_review_path(@review), notice: "Peça adicionada!"
    else
      redirect_to mechanic_review_path(@review), alert: "Erro ao adicionar peça"
    end
  end

  # DELETE /mechanic/reviews/:review_id/review_parts/:id
  # Remove uma peça associada à revisão e atualiza o subtotal.
  def destroy
    @review_part = ReviewPart.find(params[:id])
    # Atualiza o subtotal após remoção
    @review.calculate_subtotal
    @review.save
    redirect_to mechanic_review_path(@review), notice: "Peça removida!"
  end

  private

  # Localiza a revisão com base no parâmetro :review_id.
  def set_review
    @review = Review.find(params[:review_id])
  end

  # Define os parâmetros permitidos para criação de peças.
  def review_part_params
    params.require(:review_part).permit(:part_id, :quantity, :unit_price, :guarantee)
  end
end
