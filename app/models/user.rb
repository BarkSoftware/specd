class User < ActiveRecord::Base
  devise :database_authenticatable, :trackable, :omniauthable, :omniauth_providers => [:github]

  has_many :projects

  def self.from_omniauth(auth)
    user = where(provider: auth.provider, uid: auth.uid).first
    if (user)
      user.update_attributes(
        email: auth.info.email,
        token: auth.credentials.token,
        full_name: auth.info.name,
        image: auth.info.image,
        nickname: auth.info.nickname,
      )
      user
    else
      create_from_omniauth(auth)
    end
  end

  def collaborator_projects
    Collaborator.where(user_id: self.id, confirmed: true).map { |c| c.project }
  end

  def as_json(options={})
    {
      id: self.id,
      full_name: self.full_name,
      image: self.image,
    }
  end

  private

  def self.create_from_omniauth(auth)
    User.create!(
      provider: auth.provider,
      uid: auth.uid,
      email: auth.info.email,
      token: auth.credentials.token,
      full_name: auth.info.name,
      image: auth.info.image,
      nickname: auth.info.nickname,
    )
  end

end
