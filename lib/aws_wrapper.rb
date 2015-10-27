class AwsWrapper
  S3_OBJECT_MB_LIMIT = 5

  def initialize
    @bucket = S3_BUCKET
  end

  attr_reader :bucket

  def presigned_post file_type
    bucket.presigned_post(
      key: presigned_url_key,
      success_action_status: 201,
      acl: :public_read,
      secure: true,
      content_length: 1..(S3_OBJECT_MB_LIMIT*1024*1024),
      content_type: file_type,
    )
  end

  private

  def presigned_url_key
    "comments/#{day_folder}/#{SecureRandom.uuid}/${filename}"
  end

  def day_folder
    Time.now.getutc.strftime('%Y-%m-%d')
  end
end
