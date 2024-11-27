class ApplicationController < ActionController::Base
  include Pundit::Authorization
  before_action :waiting_list

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:fname, :lname, :club])
    devise_parameter_sanitizer.permit(:account_update, keys: [:fname, :lname])
  end

  private

  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_back(fallback_location: root_path)
  end

  def waiting_list
    game_param = GameParam.first
    @waiting_list = game_param[:waiting_list] if game_param
  end
end
