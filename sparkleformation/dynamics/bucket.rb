SparkleFormation.dynamic(:bucket) do |_name, _config = {}|

  lifecycle_rules = ::Array.new
  lifecycle_rules.concat _config.fetch(:lifecycle_rules, [])

  parameters("#{_name}_acl".to_sym) do
    type 'String'
    allowed_values %w(AuthenticatedRead BucketOwnerRead BucketOwnerFullControl LogDeliveryWrite Private PublicRead PublicReadWrite)
    default _config.fetch(:acl, 'Private')
    description 'Canned ACL to apply to the bucket. http://docs.aws.amazon.com/AmazonS3/latest/dev/acl-overview.html#canned-acl'
  end

  dynamic!(:s3_bucket, _name).properties do
    access_control ref!("#{_name}_acl".to_sym)
    if _config.has_key?(:bucket_name)
      bucket_name _config[:bucket_name]
    end
    # Basic support to expire objects after a number of days.
    if _config.has_key?(:lifecycle_rules)
      lifecycle_configuration do
        rules _array(
          *lifecycle_rules.map { |r| -> {
              if r.has_key?(:expiration_in_days)
                expiration_in_days r[:expiration_in_days]
              end
              status "Enabled"
            }
          }
        )
      end
    end
    tags _array(
           -> {
             key 'Environment'
             value ENV['environment']
           },
           -> {
             key 'Purpose'
             value _config.fetch(:purpose, _name)
           }
         )
  end
end
