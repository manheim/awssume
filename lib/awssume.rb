require 'aws-sdk'
require 'awssume/version'
require 'awssume/command_decorator'
require 'awssume/configuration'
require 'awssume/adapter/aws_client'

module Awssume
  def self.run
    config  = Awssume::Configuration.new
    adapter = Awssume::Adapter::AwsClient.new(
      region:            config.region,
      role_arn:          config.role_arn,
      role_session_name: config.role_session_name
    )
    creds_hash = adapter.assume
    system(Awssume::CommandDecorator.format_cmd(ARGV[0..-1], creds_hash))
  end
end
