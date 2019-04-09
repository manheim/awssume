require 'aws-sdk-core'

module Awssume
  module Adapter
    # This is aws sts client wrapper class
    class AwsClient
      attr_reader :config

      def initialize(config)
        @config = config
      end

      def assume
        sts_client.assume_role(assume_role_params).credentials.to_h
      end

      def role_session_name
        config[:role_session_name]
      end

      private

      def assume_role_params
        p = {
          role_arn: config[:role_arn],
          role_session_name: role_session_name,
          external_id: config[:external_id],
          duration_seconds: config[:duration_seconds],
        }

        p.delete(:external_id) unless p[:external_id]
        p.delete(:duration_seconds) \
          if p[:duration_seconds].nil? || p[:duration_seconds] == 0

        p
      end

      def sts_client
        Aws::STS::Client.new(region: config[:region])
      end
    end
  end
end
