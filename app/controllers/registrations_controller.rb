class RegistrationsController < Devise::RegistrationsController
 before_action :configure_permitted_parameters

  def new
    @user = User.new
    # flash.delete :recaptcha_error
  end

  def create
    # Below here is for after the mailer is setup.
    if !verify_recaptcha
      # raise "Please, check registration errors" unless @registration.valid?
      flash.delete :recaptcha_error
      build_resource(sign_up_params)
      resource.valid?
      resource.errors.add(:base, "There was an error with the recaptcha")
      clean_up_passwords(resource)
      respond_with_navigational(resource) { render :new }
    else
      # if no errors with recaptcha then continues registration
      super
      flash.delete :recaptcha_error
      # sends mail on sucessful sign up

      # super
        # redirect_to root_url
        # SiteMailer.sample_email(@user).deliver_now unless @user.invalid?
    end

  end



  private

  def configure_permitted_parameters
   devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:first_name, :last_name, :email, :password, :password_confirmation, :remember_me) }
   devise_parameter_sanitizer.permit(:sign_in) { |u| u.permit(:email, :password, :remember_me) }
   devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(:first_name, :last_name, :email, :password, :password_confirmation, :current_password) }
  end
end
