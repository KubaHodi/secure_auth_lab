class SessionsController < ApplicationController
  allow_unauthenticated_access only: %i[ new create ]
  RATE_LIMIT_STORE =
    if Rails.env.test?
      ActiveSupport::Cache::MemoryStore.new
    else
      Rails.cache
    end
  rate_limit to: 10, within: 30.minutes, only: :create, store: RATE_LIMIT_STORE, with: -> { redirect_to new_session_url, alert: "Try again later." }

  def new
    if Current.user
      redirect_to after_authentication_url
    else
      render :new
    end
  end

  def create
    if user = User.authenticate_by(params.permit(:email_address, :password))
      start_new_session_for user
      redirect_to after_authentication_url
    else
      redirect_to new_session_path, alert: "Try another email address or password."
    end
  end

  def destroy
    terminate_session
    redirect_to new_session_path
  end
end
