class UsersController < ApplicationController

  # before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  protect_from_forgery prepend: true
  # before_action :authenticate_user! do
  #     # unless admin_user(current_user) == true
  #       flash[:danger] = 'You don\'t have access to this content.'
  #       redirect_to new_user_session_path
  #   # end
  # end

  def new
    # @admin = current_user
    @user = User.new

  end

  def edit
    @user = current_user
  end

  # def show
  #   @admin = current_user
  #   # @user = User.new
  # end
  def purchases
    # @user = current_user
    # @test = Product.includes(:sales).where(sales: {email: @user.email})
    # @sale = Sale.find_by!(guid: params[:guid])
    # @items = Product.joins(:sales)
    # @items = Product.joins(:sales).where(sales: {email: @user.email})
  end

  def update
      if current_user.role_id == 4
        @admin = current_user
        @user = User.find(params[:id])
      elsif current_user.role_id < 4
        @user = current_user
      end
      if @user.update(user_params)
        flash[:success] = "#{@user.first_name} #{@user.last_name} Updated!!"
        redirect_to admins_path
      else
        if @admin = current_user

          # redirect_to edit_admin_path, :flash => { :alert => "User info was NOT updated successfully" }
          redirect_to :back, :flash => {:danger => "#{@user.errors.full_messages}"}
          # redirect_to controller: 'admins', action: 'edit', :flash => { :danger => "There were errors with your update, try again. #{@user.errors.full_messages[0]}"}
        else
          render :edit
        end
      end
  end

  def subscriptions
    # @subscription = Subscription.find_by(params[:id])
    @plans = Plan.all.order('name ASC')
    # @subscriptions = Subscription.includes(:plan).where(user_id: current_user.id).order(current_period_end: :desc).to_a
    @subscriptions = Subscription.includes(:plan).where(user_id: current_user.id).to_a
  end

  def create
    # if current_user.role_id == 4
    #   @admin = current_user
      @user = User.new
    # elsif current_user.role_id < 4
      @user = current_user
    # end

    @user = User.new(user_params)
    if @user.save!
      # SiteMailer.sample_email(@user).deliver_now
      flash[:success] = "User Created!!"
      redirect_to creates_path
    else
      flash[:alert] = "User Registration Failed!!"
      render :new
    end

  end

  def destroy
    @user = User.find(params[:id]).destroy
    if @user.destroy
      # SiteMailer.destroy_email(@user).deliver_now
      flash[:success] = "User was successfully destroyed."
      redirect_to admins_path
    else
      flash[:alert] = "User was not destroyed"
      render :new
    # respond_to do |format|
    #   format.html { redirect_to admins_path, notice: 'User was successfully destroyed.' }
    #   format.json { head :no_content }
    end
  end

  private
    def set_user
      # @admin = current_user
    end

    def user_params
      params.require(:user).permit(:id, :first_name, :last_name, :email, :password, :password_confirmation)
      # card_params = {:card_last_four => card_last_four, :card_exp_month => card_exp_month, :card_exp_year => card_exp_year, :card_type => card_type}
    end


end
