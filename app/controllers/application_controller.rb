# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pundit::Authorization
  after_action :verify_authorized, unless: :devise_controller?

  rescue_from(
    Pundit::NotAuthorizedError,
    with: :user_not_authorized
  )

  private

  def user_not_authorized
    flash[:notice] = "not authorized"

    if user_signed_in?
      redirect_to root_path
    else
      redirect_to new_user_session_path
    end
  end
end
