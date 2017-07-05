SparkleFormation.new(:buckets).load(:base, :git_rev_outputs).overrides do
  description <<EOF
Creates S3 buckets to hold data in transit and for administrative services like Chef and AWS Lambda
EOF

  # Administrative buckets
  dynamic!(:bucket, 'chef', :bucket_name => "ascent-#{ENV['environment']}-chef", :acl => 'BucketOwnerFullControl', :purpose => 'chef')
  dynamic!(:owner_write_roles_read_bucket_policy, 'chef', :bucket => 'ChefS3Bucket')

  dynamic!(:bucket, 'lambda', :bucket_name => "ascent-#{ENV['environment']}-lambda", :acl => 'BucketOwnerFullControl', :purpose => 'lambda')
  dynamic!(:owner_write_bucket_policy, 'lambda', :bucket => 'LambdaS3Bucket')

  dynamic!(:bucket, 'k8s', :bucket_name => "ascent-#{ENV['environment']}-k8s-store", :acl => 'BucketOwnerFullControl', :purpose => 'k8s')
  dynamic!(:owner_write_bucket_policy, 'k8s', :bucket => 'K8sS3Bucket')

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
