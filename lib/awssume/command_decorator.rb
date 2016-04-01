module Awssume
  class CommandDecorator
    class << self
      def generate_var_string(var_hash)
        var_hash.collect { |k,v| "AWS_#{k.upcase}='#{v}'" }.sort.join(' ')
      end

      def format_cmd(cmd, var_hash)
        cmd = cmd.join(' ') if cmd.kind_of?(Array)

        "#{generate_var_string(var_hash)} #{cmd}"
      end
    end
  end
end
