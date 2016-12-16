SparkleFormation.dynamic(:owner_write_bucket_policy) do |_name, _config={}|
  dynamic!(:s3_bucket_policy, _name).properties do
    bucket ref!(_config[:bucket])
    policy_document do
      version '2008-10-17'
      id "#{_name}SyncPolicy"
      statement _array(
        -> {
          sid "#{_name}SyncBucketAccess"
          action %w(s3:*)
          effect 'Allow'
          resource join!('arn', 'aws', 's3', '', '', ref!(_config[:bucket]), :options => { :delimiter => ':'})
          principal do
            data!['AWS'] = join!('arn', 'aws', 'iam', '', account_id!, 'root', :options => { :delimiter => ':'})
          end
        },
        -> {
          sid "#{_name}SyncObjectsAccess"
          action %w(s3:*)
          effect 'Allow'
          resource join!( join!('arn', 'aws', 's3', '', '', ref!(_config[:bucket]), :options => { :delimiter => ':'}), '*', :options => { :delimiter => '/'})
          principal do
            data!['AWS'] = join!('arn', 'aws', 'iam', '', account_id!, 'root', :options => { :delimiter => ':'})
          end
        }
      )
    end
  end
end
