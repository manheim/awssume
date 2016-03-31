require 'aws-sdk'

module Awssume
  module Adapter
    # This is aws sts client wrapper class
    class AwsClient
      attr_reader :config

      def initialize(config)
        @config = config
      end

      def assume
        sts_client.assume_role(
          role_arn: config[:role_arn],
          role_session_name: role_session_name
        ).credentials
      end

      def role_session_name
        config[:role_session_name]
      end

      private

      def sts_client
        Aws::STS::Client.new(region: config[:region])
      end
    end
  end
end
