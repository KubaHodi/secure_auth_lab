class ApplicationController < ActionController::Base
  include Authentication
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  private
  def require_admin
    return if Current.user&.admin?

    redirect_to root_path, alert: "Nie masz uprawnień do tej akcji"
  end
end
