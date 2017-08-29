SparkleFormation.new(:buckets).load(:base, :git_rev_outputs).overrides do
  description <<EOF
Creates S3 buckets to hold data in transit and for administrative services like Chef and AWS Lambda
EOF

  # Administrative buckets
  dynamic!(:bucket, 'chef', :bucket_name => "ascent-#{ENV['environment']}-chef", :acl => 'BucketOwnerFullControl', :purpose => 'chef')
  dynamic!(:owner_write_roles_read_bucket_policy, 'chef', :bucket => 'ChefS3Bucket')

  dynamic!(:bucket, 'lambda', :bucket_name => "ascent-#{ENV['environment']}-lambda", :acl => 'BucketOwnerFullControl', :purpose => 'lambda')
  dynamic!(:owner_write_bucket_policy, 'lambda', :bucket => 'LambdaS3Bucket')

  dynamic!(:bucket, 'kops', :bucket_name => "ascent-#{ENV['environment']}-kops-state-store", :acl => 'BucketOwnerFullControl', :purpose => 'kops')
  dynamic!(:owner_write_bucket_policy, 'kops', :bucket => 'KopsS3Bucket')

  dynamic!(:bucket, 'elb_logs', :bucket_name => "ascent-#{ENV['environment']}-elb-logs", :acl => 'BucketOwnerFullControl', :purpose => 'elb-logs', :lifecycle_rules => [{:expiration_in_days => 7}])
  dynamic!(:owner_write_bucket_policy, 'elb_logs', :bucket => 'ElbLogsS3Bucket')

  # Buckets for use by services
  dynamic!(:bucket, 'archival', :bucket_name => "ascent-#{ENV['environment']}-archival", :acl => 'BucketOwnerFullControl')
  dynamic!(:owner_write_bucket_policy, 'archival', :bucket => 'AssetsS3Bucket')

  dynamic!(:bucket, 'data', :bucket_name => "ascent-#{ENV['environment']}-data", :acl => 'BucketOwnerFullControl')
  dynamic!(:owner_write_bucket_policy, 'data', :bucket => 'DataS3Bucket')

  dynamic!(:bucket, 'extract', :bucket_name => "ascent-#{ENV['environment']}-extract", :acl => 'BucketOwnerFullControl')
  dynamic!(:owner_write_bucket_policy, 'archival', :bucket => 'ExtractS3Bucket')

  dynamic!(:bucket, 'raw', :bucket_name => "ascent-#{ENV['environment']}-raw", :acl => 'BucketOwnerFullControl')
  dynamic!(:owner_write_bucket_policy, 'raw', :bucket => 'RawS3Bucket')

  dynamic!(:bucket, 'customreports', :bucket_name => "ascent-#{ENV['environment']}-customreports", :acl => 'BucketOwnerFullControl')
  dynamic!(:owner_write_bucket_policy, 'customreports', :bucket => 'CustomreportsS3Bucket')
end
