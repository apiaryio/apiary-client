module Apiary
  module Command
    class Base
      attr_reader :args
      attr_reader :options

      def initialize(args = [], options = {})
        @args = args
        @options = options
      end

      def self.namespace
        self.to_s.split("::").last.downcase
      end

      attr_reader :args
      attr_reader :options

      def self.method_added(method)
        return if self == Apiary::Command::Base
        return if private_method_defined?(method)
        return if protected_method_defined?(method)

        # help = extract_help_from_caller(caller.first)
        resolved_method = (method.to_s == "index") ? nil : method.to_s
        command = [self.namespace, resolved_method].compact.join(":")
        # banner = extract_banner(help) || command

        Apiary::Command.register_command(
          :klass       => self,
          :method      => method,
          :namespace   => self.namespace,
          :command     => command
          # :banner      => banner.strip,
          # :help        => help.join("\n"),
          # :summary     => extract_summary(help),
          # :description => extract_description(help),
          # :options     => extract_options(help)
        )
      end
    end
  end
end
