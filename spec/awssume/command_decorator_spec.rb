require 'spec_helper'

describe Awssume::CommandDecorator do
  let(:var_hash) { { secret_key: '2', access_id: '1', token: '3' } }

  describe '#format_cmd' do
    it 'should concatenate a formatted command string' do
      cmd      = 'command_to_execute'
      expected = [
        "AWS_ACCESS_ID='1'", "AWS_SECRET_KEY='2'", "AWS_TOKEN='3'", cmd
      ].join(' ')
      command_string = Awssume::CommandDecorator.format_cmd(cmd, var_hash)

      expect(command_string).to eq(expected)
    end

    context 'command as an array' do
      it 'should concatenate a formatted command string' do
        cmd      = ['command', 'to', 'execute']
        expected = [
          "AWS_ACCESS_ID='1'", "AWS_SECRET_KEY='2'",
          "AWS_TOKEN='3'", 'command to execute'
        ].join(' ')
        command_string = Awssume::CommandDecorator.format_cmd(cmd, var_hash)

        expect(command_string).to eq(expected)
      end
    end
  end

  describe '#generate_var_string' do
    it 'should create a string of env vars from a hash' do
      var_string = Awssume::CommandDecorator.generate_var_string(var_hash)

      expect(var_string).to eq(
        "AWS_ACCESS_ID='1' AWS_SECRET_KEY='2' AWS_TOKEN='3'"
      )
    end

    it 'should return a sorted list of vars' do
      var_hash = { z: 'z', a: 'a', b: 'b' }
      var_string = Awssume::CommandDecorator.generate_var_string(var_hash)

      expect(var_string).to eq("AWS_A='a' AWS_B='b' AWS_Z='z'")
    end
  end
end
