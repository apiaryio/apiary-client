module Apiary
  module Okapi
    module Outputs
      class BaseOutput
        attr_reader :status

        def initialize(resources, error)
          @resources = resources
          @error = error
          @results = {
            :count => 0,
            :give_up => false,
          }
          @status = true
          get_results
        end

        def get
          p @results[:count].to_s + ' tests'
          p @results[:give_up][:error].to_s if @results[:give_up]
          @results[:tests].each { |test|
            p '-------------------------------------------------'
            p test[:test_no]
            p test[:description]
            if test[:pass]
              p 'OK'
            else
              p "FAILED"
              p test[:exp]
            end
          }
        end

        def get_results
          @results[:count] = @resources.count
          @results[:tests] = []
          
          if @error
            @results[:give_up] = {:error => @error}
            @status = false
          else
            counter = 0
            @resources.each { |res|
              counter += 1
              test_res = {
                :test_no=> counter,
                :pass => (res.validation_result.status and res.response.validation_result.status),
                :description => (res.method + ' ' + res.uri) + ((res.expanded_uri and res.uri != res.expanded_uri['url']) ? " (#{res.expanded_uri['url']}) " : '')
                }
              if not test_res[:pass]
                test_res[:exp] = {:request => {:pass => false}, :response => {:pass => false}}
                if res.validation_result.status
                  test_res[:exp][:request][:pass] = true
                else
                  test_res[:exp][:request][:reasons] = get_fail_result(res.validation_result)
                  @status = false
                end

                if res.response.validation_result.status
                  test_res[:exp][:response][:pass] = true
                else
                  test_res[:exp][:response][:reasons] = get_fail_result(res.response.validation_result)
                  @status = false
                end              
              end
            @results[:tests] << test_res
            }
          end
        end

        def get_fail_result(result)
          res = []

          if result.schema
            result.schema_res["errors"]["length"].times {|i|
              res << result.schema_res["errors"][i.to_s]["message"]
            }
          else
            if not result.body_pass
              res << 'Body does not match'
            end
          end
          if not result.header_pass
            res << 'Headers does not match'
          end
          res
        end
      end
    end
  end
end
