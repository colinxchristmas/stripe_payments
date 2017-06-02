module ApplicationHelper

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
        ""
      else
        flash_type.to_s
    end
  end
end
