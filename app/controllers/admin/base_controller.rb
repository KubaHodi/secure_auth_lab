module Admin
  class BaseController < ApplicationController
    before_action :require_admin

    private

    def require_admin
      return if Current.user&.admin?
      redirect_to root_path,
                  alert: "Nie masz uprawnień administratora."
    end
  end
end 