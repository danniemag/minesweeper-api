class Users::SessionsController < Devise::SessionsController
  respond_to :json

  before_action :check_user, only: :new

  private

  def respond_with(resource, _opts = {})
    render json: {
      success: true, message: 'Logged', email: resource.email
    }, status: :ok if user_signed_in?
  end

  def respond_to_on_destroy
    current_user ? log_out_success : log_out_failure
  end

  def log_out_success
    render json: { message: "Logged out" }, status: :ok
  end

  def log_out_failure
    render json: { message: "Logged out failure"}, status: :unauthorized
  end

  def check_user
    if params[:user].nil? || User.find_by(email: params[:user][:email]).nil?
      render json: {
        success: false, message: 'Invalid user', email: nil
      }, status: :unauthorized
    end
  end
end
