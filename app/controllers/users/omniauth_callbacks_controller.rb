class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    @user = User.from_omniauth(request.env["omniauth.auth"])
    sign_in @user, event: :authentication
    redirect_to request.env['omniauth.origin'] || '/'
  end
end
