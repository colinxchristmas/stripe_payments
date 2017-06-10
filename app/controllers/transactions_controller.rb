class TransactionsController < ApplicationController
  before_action :authenticate_user!, :product_details, except: [:thank_you]
  protect_from_forgery prepend: true

  def new
    @sale = Sale.new
  end

  def pickup
    @product = @sale.product
  end

  def create
    token = params[:stripeToken]
    @customer = CreateStripeCharge.call(current_user, charge_params, card_params, card_form_params, address_params, token)
    
    @sale = @product.sales.create!(
      stripe_id:  @customer.id,
      user_id:    current_user.id
    )

    respond_to do |format|
      if @sale.errors.blank?
        format.html { redirect_to show_purchases_path, notice: "Thank you for your purchase!" }
        format.json { render :show, status: :created, location: @sale }
      else
        format.html { render :new, alert: "There was an error with your purchase, please try again or contact support."}
        format.json { render json: @sale.errors, status: :unprocessable_entity }
      end
    end
  end

  def thank_you
  end

  private
    def product_details
      # this will be changed to the friendly_id gem later on.
      @product =  Product.find_by!(
        permalink: params[:permalink]
      )
    end

    def add_stripe_user
      if current_user.stripe_customer_set?
        # return true
      else
        find_or_create_user = CreateStripeUser.call(current_user)
        return find_or_create_user
      end
    end

    def charge_params
      {amount: @product.price, description: @product.name, receipt_email: current_user.email}
    end

    def card_params
      params.permit(:id, :stripe_id, :card_name, :card_last_four, :card_type, :card_exp_month, :card_exp_year, :user_id)
    end

    def card_form_params
      {card_on_file: params[:on_file]}
    end

    def address_params
      params.permit(:address_line_one, :address_line_two, :address_city, :address_state, :address_zip, :address_country)
    end
end
