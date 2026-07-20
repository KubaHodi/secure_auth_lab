class AccountsController < ApplicationController
  rate_limit to: 5,
  within: 10.minutes,
  only: [:destroy],
  with: -> {
    redirect_to account_path, alert: "Zbyt wiele prób usunięcia konta. Spróbuj ponownie później."
  }
  def show
  end

  def destroy
    unless ActiveModel::Type::Boolean.new.cast(params[:confirm_deletion])
      flash.now[:alert] = "Musisz potwierdzić usunięcie konta"
      return render :show, status: :unprocessable_entity
    end

    unless Current.user.authenticate(params[:password])
      flash.now[:alert] = "Niepoprawne hasło"
      return render :show, status: :unprocessable_entity
    end
    user = Current.user

    terminate_session
    user.destroy!

    redirect_to root_path,
      status: :see_other,
      notice: "Konto zostało usunięte"
  end
end
