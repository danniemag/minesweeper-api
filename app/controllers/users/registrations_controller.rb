class Users::RegistrationsController < Devise::RegistrationsController
  respond_to :json

  before_action :check_user, only: :create

  private

  def respond_with(resource, _opts = {})
    resource.persisted? ? register_success : register_failed
  end

  def register_success
    render json: { success: true, message: 'Signed up successfully', email: resource.email }
  end

  def register_failed
    render json: { success: false, message: "Sign up failure", email: resource.email }
  end

  def check_user
    if params[:user].nil? || User.find_by(email: params[:user][:email])
      render json: {
        success: false, message: 'Cannot create user', email: nil
      }, status: :bad_request
    end
  end
end
