class CardsController < ApplicationController
  before_action :set_card, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  protect_from_forgery prepend: true

  # GET /cards
  # GET /cards.json
  def index
    @cards = Card.where("user_id = ?", current_user.id).order('default_card DESC')
  end

  # GET /cards/1
  # GET /cards/1.json
  def show
  end

  # GET /cards/new
  def new
    @card = Card.new
  end

  # GET /cards/1/edit
  def edit
  end

  # POST /cards
  # POST /cards.json
  def create
    token = params[:stripeToken]
    @card = AddStripeCard.call(current_user, card_params, card_additional_params, token)
    # debugger
    respond_to do |format|
      if @card.blank?
        format.html { redirect_to cards_path, notice: "Card #{current_user.cards.last.card_last_four} was successfully created." }
        format.json { render :show, status: :created, location: @card }
      else
        format.html { render :new, alert: "There was an issue with your card, please try again."}
        format.json { render json: @card.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cards/1
  # PATCH/PUT /cards/1.json
  def update
    @card = UpdateStripeCard.call(current_user, card_params, card_additional_params)
    respond_to do |format|
      unless @card.blank?
        format.html { redirect_to @card, notice: "#{current_user.cards.last.card_last_four} was updated!" }
        format.json { render :show, status: :ok, location: @card }
      else
        format.html { render :edit }
        format.json { render json: @card.errors, status: :unprocessable_entity, alert: 'Unable to update #{current_user.cards.last.card_last_four}!' }
      end
    end
  end

  # DELETE /cards/1
  # DELETE /cards/1.json
  def destroy
    @card.destroy
    respond_to do |format|
      format.html { redirect_to cards_url, notice: 'Card was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_card
      @card = Card.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def card_params
      params.permit(:stripe_id, :card_name, :card_last_four, :card_type, :card_exp_month, :card_exp_year, :default_card, :user_id)
    end

    def card_additional_params
      params.permit(:address_line_one, :address_line_two, :address_city, :address_state, :address_zip, :address_country)
    end
end
