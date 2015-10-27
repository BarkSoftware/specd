module ControllerHelpers
  def login_user user
    @request.env['devise.mapping'] = Devise.mappings[:user]
    @user = user
    sign_in @user
  end
end
