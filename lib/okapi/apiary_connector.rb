# encoding: utf-8
require 'rest_client'
require 'json'

module Honey
  module Okapi
    class ApiaryConnector
      attr_reader :apiary_url, :blueprint

      def initialize(apiary_url, req_path, res_path)
        @apiary_url = apiary_url
        @req_path = req_path
        @res_path  = res_path
      end

      def get_response(raw_resp, json_data, error, code)
        { :resp => raw_resp,
          :data => json_data ? json_data['requests'] : nil,
          :status => json_data ? json_data['status'] : nil ,
          :error => json_data ? json_data['error'] || error : error,
          :code => code
          }
      end

      def get_requests(resources, blueprint, all_resources = false, global_vars = {})
        resources_list = []

        resources.each() do |res|
          resources_list << {
            :resource =>  res['resource'],
            :method =>  res['method'],
            :params =>  res['params']
          }
        end

        data = {
          :resources => resources_list,
          :blueprint => blueprint,
          :all_resources => all_resources,
          :global_vars => global_vars
        }.to_json()
        
        begin
          response = RestClient.post @apiary_url + @req_path, data, :content_type => :json, :accept => :json
          get_response(response, JSON.parse(response.to_str), nil, response.code.to_i)
        rescue RestClient::BadRequest, RestClient::InternalServerError  => e
          begin
            data = JSON.parse(e.http_body)
            get_response(nil, JSON.parse(e.http_body), data['error'], e.http_code.to_i)
          rescue
            get_response(nil, nil, e.to_s, e.http_code.to_i)
          end
        rescue Exception => e
          get_response(nil, nil, e.to_s, nil)
        end

      end

      def get_results(resources, blueprint)
        resources_list = []
        resources.each() do |res|
          resources_list << {
            :request => {
              :uri =>  res.uri,
              :expandedUri => res.expanded_uri,
              :method =>  res.method,
              :headers =>  res.headers,
              :body =>  res.body,
            },
            :response => {
              :status =>  res.response.status,
              :headers => res.response.headers ,
              :body =>  res.response.body
            }
          }
        end

        data = {
          :resources => resources_list,
          :blueprint => blueprint
        }.to_json()

        begin
          response = RestClient.post @apiary_url + @res_path, data, :content_type => :json, :accept => :json
          get_response(response, JSON.parse(response.to_str), nil, response.code.to_i)
        rescue RestClient::BadRequest, RestClient::InternalServerError  => e
          begin
            get_response(nil, JSON.parse(e.http_body), data['error'], e.http_code.to_i)
          rescue
            get_response(nil, nil, e.to_s, e.http_code.to_i)
          end
        rescue Exception => e
          get_response(nil, nil, e.to_s, nil)
        end
      end
    end
  end
end
