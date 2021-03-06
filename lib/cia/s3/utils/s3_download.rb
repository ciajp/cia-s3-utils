require 'aws/s3'
require 'active_support'
require 'active_support/core_ext/object/blank'

module Cia
  module S3
    module Utils

      class S3Download

        # Initialize the download class
        #
        # bucket - The bucket you want to upload to
        # aws_key - Your key generated by AWS defaults to the environemt setting AWS_KEY_ID
        # aws_secret - The secret generated by AWS
        # aws_region - The region you want to use
        # aws_endpoint - The endpoint of s3 bucket
        #
        def initialize(bucket, aws_key = ENV['AWS_KEY_ID'], aws_secret = ENV['AWS_SECRET'], region = ENV['AWS_REGION'], aws_end_point = ENV['AWS_END_POINT'])

          @connection       = AWS::S3.new(access_key_id: aws_key, secret_access_key: aws_secret, region: region)#, s3_endpoint: aws_end_point
          @s3_bucket        = @connection.buckets[bucket]
        end

        def download(path)
            object = @s3_bucket.objects[path]
            if object.exists?
                return object
            else
                nil
            end
        end

      end

    end
  end
end
