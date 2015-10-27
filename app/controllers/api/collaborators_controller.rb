module Api
  class CollaboratorsController < BaseController
    def create
      authorize! :invite_collaborator, project
      unless collaborator_exists?
        create_collaborator!
        notify_collaborator!
      end
      render json: collaborator.as_json, status: 201
    end

    def confirm
      fail 'login required to confirm token' if current_user.nil?
      @collaborator = collaborator_by_token
      collaborator.user_id = current_user.id
      add_github_collaborator
      collaborator.update!(user_id: current_user.id, confirmed: true)
      render json: { project_id: collaborator.project.id }, status: 200
    end

    def show
      @collaborator = collaborator_by_token
      render json: collaborator_json, status: 200
    end

    def destroy
      @collaborator = collaborator_by_id
      if owner?
        project = collaborator.project
        if (collaborator.user)
          GithubApi.new(current_user.token).delete(
            "#{project.github_repository}/collaborators/#{collaborator.user.nickname}"
          )
        end
        collaborator.destroy
        render json: {}, status: 200
      else
        render json: {}, status: 403
      end
    end

    private

    attr_accessor :collaborator

    def add_github_collaborator
      project = collaborator.project
      owner_token = project.user.token
      api = GithubApi.new(owner_token)
      url = "#{project.github_repository}/collaborators/#{current_user.nickname}"
      if project.is_organization_repo?
        api.put(url, permission: 'admin')
      else
        api.put(url)
      end
    end

    def owner?
      collaborator.project.user.id == current_user.id
    end

    def collaborator_by_id
      Collaborator.find(params[:id])
    end

    def collaborator_by_token
      Collaborator.find_by!(invite_token: params[:invite_token])
    end

    def collaborator_json
      {
        project_title: collaborator.project.title,
        owner_name: collaborator.project.user.full_name,
      }
    end

    def project
      @project ||= Project.find(params[:project_id])
    end

    def invite_token
      @invite_token ||= SecureRandom.uuid
    end

    def create_collaborator!
      @collaborator = project.collaborators.create! collaborator_params
    end

    def collaborator_exists?
      @collaborator = project.collaborators.find_by_email(params[:email])
      collaborator.present?
    end

    def collaborator_params
      {
        invite_token: invite_token,
        project_id: project.id,
        email: params[:email],
        type: params[:type],
      }
    end

    def notify_collaborator!
      CollaboratorMailer.invite(@collaborator).deliver
    end
  end
end
