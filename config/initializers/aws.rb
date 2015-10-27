AWS.config(Settings.aws.deep_symbolize_keys)
S3_BUCKET = AWS::S3.new.buckets[Settings.s3_bucket]
