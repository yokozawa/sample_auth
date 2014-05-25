class Api::RegistrationsController < Devise::RegistrationsController
  skip_before_filter :verify_authenticity_token,
                     :if, -> (c){ c.request.format == 'application/json' }
  respond_to :json

  def create
    user = User.new(user_params)

    if user.save
      render status: 201,
              json: { status: :ok, user: user }
    else
      warden.custom_failure!
      render status: 201,
              json: { status: :ng, errors: user.errors }
    end
  end

  def user_params
    params.require(:user).permit(:email, :password)
  end

end
