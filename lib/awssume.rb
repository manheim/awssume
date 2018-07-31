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
      role_session_name: config.role_session_name,
      external_id:       config.external_id,
      duration_seconds:  config.duration_seconds,
    )
    aws_env = {
      'AWS_REGION'         => config.region,
      'AWS_DEFAULT_REGION' => config.region
    }
    creds_hash = adapter.assume
    fmt_cmd    = Awssume::CommandDecorator.format_cmd(ARGV[0..-1], creds_hash)

    handle_exit { system(aws_env, fmt_cmd) }
  end

  def self.handle_exit(&block)
    block.call ? true : exit(1)
  end
end
