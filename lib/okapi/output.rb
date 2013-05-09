# encoding: utf-8
Dir["#{File.dirname(__FILE__)}/outputs/*.rb"].each { |f|   require(f)  }

module Apiary
  module Okapi
    class Output
      def self.get(output,resources, error)
        output = Apiary::Okapi::Outputs.const_get(output.to_s.capitalize).send(:new, resources, error)
        output.get()
        output.status
      end
    end
  end
end
