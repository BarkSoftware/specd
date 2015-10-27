module Api
  class UploadsController < BaseController
    before_action :authenticate_user!

    def create
      @presigned_post = AwsWrapper.new.presigned_post params[:file_type]
      render json: presigned_post_as_json, status: 201
    end

    private

    def presigned_post_as_json
      {
        url: @presigned_post.url.to_s,
        fields: @presigned_post.fields,
      }
    end
  end
end
