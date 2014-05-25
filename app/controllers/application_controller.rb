class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

private

  def authenticate_user_from_token!
    user_id = request.headers[:HTTP_X_USER_ID]
    token = request.headers[:HTTP_X_AUTH_TOKEN]
puts "userid:#{user_id}"
puts "token:#{token}"
    user = user_id && User.find(user_id)
    if user && Devise.secure_compare(user.authentication_token, token)
puts "auth"
      sign_in user, store: false
    else
puts "no auth"    
      render status: 200,
              json: { status: :ng }
    end
  end

end
