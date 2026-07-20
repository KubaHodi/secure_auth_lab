module Admin
  class UsersController < BaseController
    before_action :set_user, only: %i[show update]

    def index
      @users = User.order(created_at: :desc)
    end

    def show
    end

    def update
      if removing_own_admin_role?
        redirect_to admin_user_path(@user),
                    alert: "Nie możesz odebrać sobie roli administratora."
        return
      end

      if @user.update(role_params)
        redirect_to admin_user_path(@user),
                    notice: "Rola użytkownika została zmieniona."
      else
        render :show, status: :unprocessable_entity
      end
    end

    private

    def set_user
      @user = User.find(params[:id])
    end

    def role_params
      params.expect(user: [:role])
    end

    def removing_own_admin_role?
      @user == Current.user &&
        Current.user.admin? &&
        role_params[:role] != "admin"
    end
  end
end