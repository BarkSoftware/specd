class Api::BaseController < ApplicationController
  protect_from_forgery with: :exception
  skip_before_action :verify_authenticity_token, if: :json_request?

  def index
    if signed_in?
      render json: {
        github: {
          token: current_user.token,
          username: current_user.nickname,
          full_name: current_user.full_name,
        },
        logout_url: "#{host}/users/sign_out",
        profile_image: current_user.image,
      }
    else
      render json: {
        login_url: "#{host}/users/auth/github",
      }, status: 401
    end
  end

  private

  def host
    "#{request.protocol}#{request.host}:#{request.port}"
  end

  def json_request?
    request.format.json?
  end
end
