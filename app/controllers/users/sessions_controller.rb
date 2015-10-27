class Users::SessionsController < Devise::SessionsController
  skip_before_action :verify_authenticity_token

  def destroy
    sign_out
    return render json: { login_url: "#{host}/users/auth/github" } if json_request?
    redirect_to '/'
  end

  private

  def host
    "#{request.protocol}#{request.host}:#{request.port}"
  end

  def json_request?
    request.format.json?
  end
end
