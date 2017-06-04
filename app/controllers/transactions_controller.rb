class TransactionsController < ApplicationController
  before_action :authenticate_user!, :product_details, only: [:show, :edit, :update, :destroy]
  protect_from_forgery prepend: true

  def new
    @sale = Sale.new
  end

  def pickup
    @sale = Sale.find_by!(guid: params[:guid])
    @product = @sale.product
  end

  def create
    # error handling within the stripe services has NOT been verified! Need to go back and check to make sure it's working.
    token = params[:stripeToken]
    # debugger
    customer = CreateStripeCharge.call(current_user, charge_params, card_params, card_form_params, token)
    @sale = @product.sales.create!(
      stripe_id:  customer.id,
      user_id:    current_user.id
    )
    # debugger
    if @sale.save!
      redirect_to purchase_thanks_path
      # Nice to have additions if planning to have admin and user notified of successful transaction
      # TransactionMailer.new_transaction_notification(current_user, @product).deliver
      # TransactionMailer.new_admin_transaction_notification(current_user, @product).deliver
      flash[:success] = 'Thank you for your purchase!'
    else
      render :new
      flash[:danger] = 'There was an error with your purchase!'
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

    def address_params_validator(address_params)
      # will possibly use in the future.
      address_params.values.any?{|v| v.nil? || v.length == 0}
    end

    def charge_params
      {amount: @product.price, description: @product.name, receipt_email: current_user.email}
    end

    def card_params
      {stripe_id: params[:stripe_id], card_last_four: params[:card_last_four], card_exp_month: params[:card_exp_month], card_exp_year: params[:card_exp_year], card_type: params[:card_brand]}
    end

    def card_form_params
      {card_on_file: params[:on_file]}
    end

    def address_params
      # not used now as stripe.js handles the address fields but possibly use for future model additions.
      {address_line1: params[:address_one], address_line2: params[:address_two], address_city: params[:address_city], address_state: params[:address_state], address_zip: params[:address_zip]}
    end
end
