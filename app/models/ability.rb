class Ability
  include CanCan::Ability

  def initialize(user)
    @user = user

    can [:read, :update, :invite_collaborator], Project do |project|
      owner_or_collaborator? project
    end

    can [:destroy, :invite_collaborator], Project do |project|
      owner? project
    end

    can :manage, Issue do |issue|
      owner_or_collaborator? issue.column.project
    end

  end

  attr_reader :user

  def owner_or_collaborator? project
    owner?(project) || project.collaborators.find_by_user_id(user.id).present?
  end

  def owner? project
    project.user_id == user.id
  end
end
