class Collaborator < ActiveRecord::Base
  belongs_to :project
  belongs_to :user
  self.inheritance_column = :_type_disabled

  def as_json
    if user.present?
      user.as_json.merge(id: id, type: type)
    else
      {
        id: id,
        full_name: email,
        type: 'Invite sent to',
      }
    end
  end
end
