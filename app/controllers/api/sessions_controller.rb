class Api::SessionsController < Devise::SessionsController
  before_filter :authenticate_user_from_token!, only: [:info]
  skip_before_filter :verify_authenticity_token,
                     :if, -> (c){ c.request.format == 'application/json' }
  respond_to :json

  def create
    warden.authenticate!(scope: resource_name, recall: "#{controller_path}#failure")
    render status: 200,
           json: { status: :ok, user: current_user }
  end

  def destroy
    warden.authenticate!(scope: resource_name, recall: "#{controller_path}#failure")
    current_user.update_column(:authentication_token, nil)
    render status: 200,
           json: { status: :ok, user: nil }
  end

  def failure
    render status: 401,
           json: { status: :ng, error: "Login Failed", user: nil }
  end

  def renew_token
    user_id = request.headers[:HTTP_X_USER_ID]
    user = user_id && User.find(user_id)

    if user.present?
      user.renew_authentication_token
      render json: {user: user,  status: :ok}
    else
      render json: {status: :ng}
    end
  end

  def info
    render status: 200,
           json: { status: :ok, user: current_user }
  end

end
