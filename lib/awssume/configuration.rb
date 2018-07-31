module Awssume
  # A class for managing the properties needed for assuming a role
  class Configuration
    def self.default_session_name
      "AwssumedSession#{Time.new.to_i}"
    end

    # Defaults must have a value: a value passed in or a hardcoded default
    # The utility will exit with an error if a value is missing for a default
    def self.defaults
      {
        region:            ENV['AWS_REGION'] || ENV['AWS_DEFAULT_REGION'],
        role_arn:          ENV['AWS_ROLE_ARN'],
        role_session_name: ENV['AWS_ROLE_SESSION_NAME'] || default_session_name,
      }
    end

    # Options are not required to have a value
    # The utility will function without issue if an optional value is missing
    def self.options
      {
        external_id:       ENV['AWS_ROLE_EXTERNAL_ID'],
        duration_seconds:  ENV['AWS_ROLE_DURATION_SECONDS'].to_i
      }
    end

    def self.attrs
      self.defaults.merge(self.options)
    end

    attr_accessor(*attrs.keys)

    def initialize(opts = {})
      attrs.each do |k, _|
        attr_val = validate_attrs(attrs.merge(opts), k)
        instance_variable_set("@#{k}", attr_val)
      end
    end

    private

    def is_optional(attr_key)
      self.class.options.keys.include?(attr_key)
    end

    def validate_attrs(attrs, attr_key)
      throwout_nils(attrs).fetch(attr_key) do
        unless is_optional(attr_key)
          raise ArgumentError, missing_attr_error_msg(attr_key)
        end
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
      self.class.attrs
    end
  end
end
