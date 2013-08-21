# encoding: utf-8
require 'rest_client'

module Honey
  module Okapi
    class Test
      def initialize(blueprint_path, test_spec_path, test_url, output, apiary_url)
        @blueprint_path = blueprint_path
        @test_spec_path = test_spec_path
        @test_url       = test_url
        @output_format  = output
        @apiary_url     = apiary_url
        @req_path       = GET_REQUESTS_PATH
        @res_path       = GET_RESULTS_PATH
        @connector = Honey::Okapi::ApiaryConnector.new(@apiary_url, @req_path, @res_path)
        @proces_all_bp_resources = false
        @output = []
        @resources = []
        @error = nil        
      end

      def run
        begin
          test()
        rescue Exception => e
          @resources = []
          @error = e
        end        
        Honey::Okapi::Output.get(@output_format, @resources, @error)
      end

      def test
        prepare()
        if not @resources.empty?
          get_responses
          evaluate
        else
          raise Exception, 'No resources provided'
        end
      end

      def prepare
        @resources = []
        parser = get_test_spec_parser(@test_spec_path)
        resources = parser.resources
        counter = 0

        resources.each { |res|
          counter += 1
          raise Exception, "Rresource not defined for item #{counter.to_d} in #{@test_spec_path}" unless res["resource"]
          raise Exception, "Method not defined for resource #{res["resource"].to_s} in #{@test_spec_path}" unless res["method"]
        }

        @proces_all_bp_resources = parser.proces_all_bp_resources
        data = get_requests_spec(resources, parser.global_vars)
        
        if data[:error] or data[:code] != 200
          raise Exception, 'Can not get request data from Apiary: ' + data[:error] ? data[:error] : ''
        end
         
        data[:data].each do |res|
          raise Exception, 'Resource error "' + res['error'] + '" for resource "' + res["method"] + ' ' + res["uri"]  + '"' if res['error']
          @resources << Honey::Okapi::Resource.new(res["uri"], res["method"], res["params"], res["expandedUri"], res["headers"], res["body"])          
        end

        @resources      
      end

      def blueprint
        @blueprint ||= parse_blueprint(@blueprint_path)
      end

      def get_responses
        @resources.each { |resource|
          params = {:method => resource.method, :url => @test_url + resource.expanded_uri['url'], :headers => resource.headers || {}, :payload=> resource.body}
          begin            
            response = RestClient::Request.execute(params)

            raw_headers = response.raw_headers.inject({}) do |out, (key, value)|
                            out[key] = %w{ set-cookie }.include?(key.downcase) ? value : value.first
                            out
                          end

            resource.response =  Honey::Okapi::Response.new(response.code, raw_headers, response.body)
          rescue Exception => e
            raise Exception, 'Can not get response for: ' + params.to_json + ' (' + e.to_s + ')'
          end
          }

      end

      def evaluate

        data = @connector.get_results(@resources, blueprint)
        if data[:error] or data[:code] != 200
          raise Exception, 'Can not get evaluation data from apiary: ' + data[:error] ? data[:error] : ''
        end
        
        data[:data].each { |validation|
          @resources.each { |resource|
            if validation['resource']['uri'] == resource.uri and validation['resource']['method'] == resource.method
              resource.validation_result = Honey::Okapi::ValidationResult.new()
              resource.validation_result.error = validation['errors']
              resource.validation_result.schema_res = validation["validations"]['reqSchemaValidations']
              resource.validation_result.body_pass = !validation["validations"]['reqData']['body']['isDifferent']
              resource.validation_result.body_diff = validation["validations"]['reqData']['body']['diff']
              resource.validation_result.header_pass = !validation["validations"]['reqData']['headers']['isDifferent']
              resource.validation_result.header_diff = validation["validations"]['reqData']['headers']['diff']

              resource.response.validation_result = Honey::Okapi::ValidationResult.new()
              resource.response.validation_result.error = validation['errors']
              resource.response.validation_result.schema_res = validation["validations"]['resSchemaValidations']
              resource.response.validation_result.body_pass = !validation["validations"]['resData']['body']['isDifferent']
              resource.response.validation_result.body_diff = validation["validations"]['resData']['body']['diff']
              resource.response.validation_result.header_pass = !validation["validations"]['resData']['headers']['isDifferent']
              resource.response.validation_result.header_diff = validation["validations"]['resData']['headers']['diff']
            end

          }
        }
      end      

      def get_test_spec_parser(test_spec)
        Honey::Okapi::Parser.new(test_spec)                
      end

      def parse_blueprint(blueprint_path)
        if not File.exist? blueprint_path
          raise Exception, "Blueprint file '#{blueprint_path}' not found"
        end
        File.read(blueprint_path)
      end

      def get_requests_spec(resources, global_vars)
        @connector.get_requests(resources, blueprint, @proces_all_bp_resources, global_vars)
      end

    end
  end
end

