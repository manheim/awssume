require 'spec_helper'

describe Awssume do
  it 'has a version number' do
    expect(Awssume::VERSION).not_to be nil
  end

  describe '.run' do
    before do
      fake_config = double('fake_config')
      [:region, :role_arn, :role_session_name, :external_id].each do |method|
        allow(fake_config).to receive(method)
      end

      fake_client = double('fake_client')
      allow(fake_client).to receive(:assume).and_return({})

      allow(Awssume::Configuration).to receive(:new)
        .and_return(fake_config)

      allow(Awssume::Adapter::AwsClient).to receive(:new)
        .and_return(fake_client)

      allow(Awssume).to receive(:system).and_return(status)
    end

    subject { -> { Awssume.run } }

    context 'when the command returns a failing status' do
      let(:status) { false }
      it { is_expected.to raise_error(SystemExit) }
    end

    context 'when the command returns a passing status' do
      let(:status) { true }
      it { is_expected.to_not raise_error }
    end
  end
end
