class SubscriptionsController < ApplicationController
  before_action :set_subscription, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  protect_from_forgery prepend: true

  # GET /subscriptions
  # GET /subscriptions.json
  def index
    @subscriptions = Subscription.all
    @plans = Plan.all
  end

  # GET /subscriptions/1
  # GET /subscriptions/1.json
  def show
  end

  # GET /subscriptions/new
  def new
    @subscription = Subscription.new
    @plan = Plan.find(params[:plan_id])
  end

  # GET /subscriptions/1/edit
  def edit
  end

  # POST /subscriptions
  # POST /subscriptions.json
  def create
    @plan = Plan.find(params[:plan_id])
    @subscription = CreateStripeSubscription.call(
      @plan,
      current_user.email,
      card_params,
      card_form_params,
      params[:stripeToken]
    )

    respond_to do |format|
      if @subscription.errors.blank?
        format.html { redirect_to show_subscriptions_path, success: 'Thank you for your purchase!' +
          'Check your email for further instructions' +
          ' on getting started.' }
        format.json { render :show, status: :created, location: @subscription }
      else
        format.html { render :new }
        format.json { render json: @subscription.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /subscriptions/1
  # PATCH/PUT /subscriptions/1.json
  def update
    respond_to do |format|
      if @subscription.update(subscription_params)
        format.html { redirect_to @subscription, notice: 'Subscription was successfully updated.' }
        format.json { render :show, status: :ok, location: @subscription }
      else
        format.html { render :edit }
        format.json { render json: @subscription.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /subscriptions/1
  # DELETE /subscriptions/1.json
  def destroy
    @subscription.destroy
    respond_to do |format|
      format.html { redirect_to subscriptions_url, notice: 'Subscription was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_subscription
      @subscription = Subscription.find(params[:id])
    end

    def card_params
      {stripe_id: params[:stripe_id], card_last_four: params[:card_last_four], card_exp_month: params[:card_exp_month], card_exp_year: params[:card_exp_year], card_type: params[:card_brand]}
    end

    def card_form_params
      {card_on_file: params[:on_file]}
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def subsription_params
      params.require(:subscription).permit(:plans_attributes => [:name, :stripe_id])
    end
end
