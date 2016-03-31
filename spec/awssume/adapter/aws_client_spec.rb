require 'spec_helper'

describe Awssume::Adapter::AwsClient do
  let(:assume_role_response) do
    OpenStruct.new(
      :credentials => OpenStruct.new(
        :access_key_id     => 'ABCDEFGHIJKLMNOPQRST',
        :secret_access_key => 'XXXXXXXXXXXXXXXXXXXX',
        :session_token     => 'SUUUUUUUUPERLONGTOKEN',
        :expiration        => Time.new('2016-03-28 21:27:29 UTC')
      ),
      :assumed_role_user => OpenStruct.new(
        :assumed_role_id => 'AXXXXXXXXXXXXXXXXXXXX:test',
        :arn             => 'arn:aws:sts::XXXXXXXXXXXX:assumed-role/aRole/test'
      )
    )
  end

  let(:sts_stub) do
    sts = Aws::STS::Client.new(stub_responses: true)
    sts.stub_responses(:assume_role, assume_role_response)
    sts
  end

  let(:config_hash) do
    {
      region:   'us-east-1',
      role_arn: 'arn:aws:iam::XXXXXXXXXXXX:role/aRole',
      role_session_name: 'test-deploy'
    }
  end

  let(:adapter) { Awssume::Adapter::AwsClient.new(config_hash) }

  before(stub_sts: true) do
    allow(adapter).to receive(:sts_client).and_return(sts_stub)
    allow(sts_stub).to receive(:assume_role).and_return(assume_role_response)
  end

  describe '#assume', stub_sts: true do
    it 'should call assume_role with proper params' do
      expect(sts_stub).to receive(:assume_role).with(
        role_arn:          'arn:aws:iam::XXXXXXXXXXXX:role/aRole',
        role_session_name: 'test-deploy'
      )

      adapter.assume
    end

    context 'successful response' do
      subject(:response) { adapter.assume }

      it 'should have access_key_id' do
        expect(response.access_key_id).to eq('ABCDEFGHIJKLMNOPQRST')
      end

      it 'should have secret_access_key' do
        expect(response.secret_access_key).to eq('XXXXXXXXXXXXXXXXXXXX')
      end

      it 'should have session_token' do
        expect(response.session_token).to eq('SUUUUUUUUPERLONGTOKEN')
      end
    end
  end
end
