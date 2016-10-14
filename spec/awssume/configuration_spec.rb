require 'spec_helper'

describe Awssume::Configuration do
  context '#initialize' do
    describe 'missing attributes' do
      let(:invalid_args) do
        {
          role_arn: 'arn:aws:iam::123456789012:user/David',
          role_session_name: 'testDeploy'
        }
      end

      let(:missing_arg) { 'region' }

      it 'raises ArgumentError when attributes are missing' do
        expect { Awssume::Configuration.new(invalid_args) }
          .to raise_error(ArgumentError)
      end

      it 'raises Argument error with missing attribute in message' do
        expected_msg  = "Missing '#{missing_arg}'\n"
        expected_msg += "Args should be passed in or set in the env:\n"
        expected_msg += "AWS_#{missing_arg.upcase}=value awssume"

        expect { Awssume::Configuration.new(invalid_args) }
          .to raise_error(/#{expected_msg}/)
      end
    end

    describe 'missing optional attributes' do
      let(:valid_args) do
        {
          region: 'us-east-1',
          role_arn: 'arn:aws:iam::123456789012:user/David',
          role_session_name: 'testDeploy'
        }
      end

      it 'does not raise error when optional attributes are missing' do
        expect { Awssume::Configuration.new(valid_args) }
          .not_to raise_error
      end
    end

    it 'should provide default session name if none is provided' do
      config = Awssume::Configuration.new(
        role_arn: 'arn:aws:iam::123456789012:user/David',
        region:   'us-east-1'
      )

      expect(config.role_session_name).to match(/AwssumedSession/)
    end

    it 'can receive custom attributes' do
      config = Awssume::Configuration.new(
        region:            'us-east-1',
        role_arn:          'arn:aws:iam::123456789012:user/David',
        role_session_name: 'testDeploy'
      )

      expect(config.region).to eq('us-east-1')
      expect(config.role_arn).to eq('arn:aws:iam::123456789012:user/David')
      expect(config.role_session_name).to eq('testDeploy')
    end

    it 'can set attributes with env vars' do
      stub_const(
        'ENV',
        'AWS_REGION'            => 'us-east-1',
        'AWS_ROLE_ARN'          => 'arn:aws:iam::123456789012:user/Gary',
        'AWS_ROLE_SESSION_NAME' => 'testSessionName',
        'AWS_ROLE_EXTERNAL_ID'  => '12345abc'
      )
      config = Awssume::Configuration.new

      expect(config.region).to eq('us-east-1')
      expect(config.role_arn).to eq('arn:aws:iam::123456789012:user/Gary')
      expect(config.role_session_name).to eq('testSessionName')
      expect(config.external_id).to eq('12345abc')
    end

    it 'can use AWS_DEFAULT_REGION for region' do
      stub_const(
        'ENV',
        'AWS_DEFAULT_REGION'    => 'us-east-1',
        'AWS_ROLE_ARN'          => 'arn:aws:iam::123456789012:user/Gary',
        'AWS_ROLE_SESSION_NAME' => 'testSessionName'
      )
      config = Awssume::Configuration.new

      expect(config.region).to eq('us-east-1')
    end
  end
end
