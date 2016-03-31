module Awssume
  # A class for managing the properties needed for assuming a role
  class Configuration
    def self.default_session_name
      "AwssumedSession#{Time.new.to_i}"
    end

    def self.defaults
      {
        region:            ENV['AWS_REGION'],
        role_arn:          ENV['AWS_ROLE_ARN'],
        role_session_name: ENV['AWS_ROLE_SESSION_NAME'] || default_session_name
      }
    end

    attr_accessor(*defaults.keys)

    def initialize(opts = {})
      attrs.each do |k, _|
        attr_val = validate_attrs(attrs.merge(opts), k)
        instance_variable_set("@#{k}", attr_val)
      end
    end

    private

    def validate_attrs(attrs, attr_key)
      throwout_nils(attrs).fetch(attr_key) do
        raise ArgumentError, missing_attr_error_msg(attr_key)
      end
    end

    def missing_attr_error_msg(key)
      [
        "Missing '#{key}'",
        'Args should be passed in or set in the env:',
        "AWS_#{key.upcase}=value awssume"
      ].join("\n")
    end

    def throwout_nils(attrs)
      attrs.reject { |_, v| v.nil? }
    end

    def attrs
      self.class.defaults
    end
  end
end
