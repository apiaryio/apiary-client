# encoding: utf-8

module Apiary
  module Helpers
    def api_description_source_path(path)
      raise "Invalid path #{path}" unless File.exist? path
      return path if File.file? path
      source_path = choose_one(path)
      return source_path unless source_path.nil?
      raise 'No API Description Document found'
    end

    def api_description_source(path)
      source_path = api_description_source_path(path)
      source = nil
      File.open(source_path, 'r:bom|utf-8') { |file| source = file.read }
      source
    end

    def convert_from_json(add)
      JSON.parse(add).to_yaml
    rescue JSON::ParserError => e
      abort "Unable to convert input document to yaml: #{e.message.lines.first}"
    end

    protected

    def choose_one(path)
      apib_path = api_blueprint(path)
      swagger_path = swagger(path)

      if apib_path && swagger_path
        warn 'WARNING: Both apiary.apib and swagger.yaml are present. The apiary.apib file will be used. To override this selection specify path to desired file'
      end

      apib_path || swagger_path
    end

    def api_blueprint(path)
      source_path = File.join(path, 'apiary.apib')
      return source_path if File.exist? source_path
      nil
    end

    def swagger(path)
      source_path = File.join(path, 'swagger.yaml')
      return source_path if File.exist? source_path
      nil
    end
  end
end
