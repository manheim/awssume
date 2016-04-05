require 'spec_helper'

describe Awssume do
  it 'has a version number' do
    expect(Awssume::VERSION).not_to be nil
  end

  describe '.run' do
    it 'exits badly when the command fails' do
      fake_config = double('fake_config')
      allow(fake_config).to receive(:region)
      allow(fake_config).to receive(:role_arn)
      allow(fake_config).to receive(:role_session_name)

      fake_client = double('fake_client')
      allow(fake_client).to receive(:assume).and_return({})

      allow(Awssume::Configuration).to receive(:new)
        .and_return(fake_config)
      allow(Awssume::Adapter::AwsClient).to receive(:new)
        .and_return(fake_client)
      allow(Awssume).to receive(:system).and_return(false)

      expect{ Awssume.run }.to raise_error(SystemExit)
    end

    it 'exits goodly when the command fails' do
      fake_config = double('fake_config')
      allow(fake_config).to receive(:region)
      allow(fake_config).to receive(:role_arn)
      allow(fake_config).to receive(:role_session_name)

      fake_client = double('fake_client')
      allow(fake_client).to receive(:assume).and_return({})

      allow(Awssume::Configuration).to receive(:new)
        .and_return(fake_config)
      allow(Awssume::Adapter::AwsClient).to receive(:new)
        .and_return(fake_client)
      allow(Awssume).to receive(:system).and_return(true)

      expect{ Awssume.run }.to_not raise_error
    end
  end
end
