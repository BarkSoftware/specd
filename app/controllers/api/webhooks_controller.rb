module Api
  class WebhooksController < BaseController
    skip_before_action :verify_authenticity_token

    def create
      verify_signature
      WebhookProcessor.new(project, params[:webhook]).process
      render json: {}, status: 200
    end

    private

    def verify_signature
      payload_body = request.body.read
      signature = 'sha1=' + OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha1'), project.webhook_secret, payload_body)
      fail "Signatures didn't match!" unless Rack::Utils.secure_compare(signature, request.env['HTTP_X_HUB_SIGNATURE'])
    end

    def project
      Project.find(params[:project_id])
    end
  end
end
