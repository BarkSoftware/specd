module Api
  class ProjectsController < BaseController
    def show
      project = Project.find(params[:id])
      authorize! :read, project
      WebhookCorrector.new(current_user, project).correct
      render json: project, status: 200
    end

    def index
      projects = current_user.projects + current_user.collaborator_projects
      render json: projects, status: 200
    end

    def create
      project = ProjectCreator.new(current_user).create(project_params)
      render json: project, status: 201
    end

    def update
      project = Project.find(params[:id])
      authorize! :update, project
      if params[:archive]
        project.archived = true
        project.save!
      end
      if params[:unarchive]
        project.archived = false
        project.save!
      end
      render json: {}, status: 200
    end

    private

    def project_params
      params.require(:project).permit(
        :title, :description, :github_repository, :estimate_type, :cost_method
      )
    end
  end
end
