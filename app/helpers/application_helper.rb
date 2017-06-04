module ApplicationHelper

  def formatted_price(amount)
    sprintf("$%0.2f", amount / 100.0)
  end

  private

  def custom_bootstrap_flash(flash_type)
    case flash_type
      when "success"
        "alert-success"
      when "error"
        "alert-error"
      when "alert"
        "alert-info"
      when "notice"
        "alert-info"
      when "timedout"
        "timedout"
      else
        flash_type.to_s
    end
  end
end
