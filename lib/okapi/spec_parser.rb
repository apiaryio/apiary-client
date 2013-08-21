# encoding: utf-8
require 'json'

module Honey
  module Okapi
    class Parser
      attr_reader :data, :resources, :proces_all_bp_resources, :global_vars

      def initialize(spec_path)
        if not File.exist? spec_path
          raise Exception, "Test spec. file '#{spec_path}' not found"
        end
        @data = read_file(spec_path)
        @proces_all_bp_resources = false
      end

      def resources
        @resources ||= parse_data
      end

      def read_file(path)
        @data = []
          File.open(path).each do |line|
            @data << line if line.strip != ""
          end
        @data
      end

      def substituite_vars(local, global)
        tmp = {}
        global.each {|k,v|
          tmp[k] = v
        }
        local.each {|k,v|
          tmp[k] = v
        }
        tmp
      end

      def parse_data
        global_vars = {}
        resources = []
        @data.each { |res|
          if res.index('CONTINUE') == 0
            @proces_all_bp_resources = true
            next
          end

          if res.index('VARS') == 0
            splited = res.split(' ',2)
            begin
              global_vars = JSON.parse splited[1] if splited[1] and splited[1] != ''
            rescue Exception => e
              raise Exception, "can not parse global parameters (#{e})"
            end
            next
          end

          splited = res.split(' ',3)

          begin
            splited[2] = JSON.parse splited[2] if splited[2] and splited[2] != ''
          rescue Exception => e
            raise Exception, 'can not parse parameters for resource:' + res + "(#{e})"
          end
          
          if splited[1] and splited[1] != '' and splited[0] and splited[0] != ''
            out = {
              'resource' => splited[1],
              'method' => splited[0],
              'params' => substituite_vars(splited[2] || {}, global_vars)
              }
            resources << out
          end
        }

        @global_vars = global_vars
        resources
      end
    end
  end
end
