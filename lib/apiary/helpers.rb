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

    protected

    def choose_one(path)
      apibPath = api_blueprint(path)
      swaggerPath = swagger(path)

      if apibPath && swaggerPath
        warn 'WARNING: Both apiary.apib and swagger.yaml are present. apiary.apib will be used. To override this selection specify path to desired file'
      end

      apibPath || swaggerPath
    end

    def api_blueprint(path)
      source_path = File.join(path, 'apiary.apib')
      return source_path if File.exist? source_path
      return nil
    end

    def swagger(path)
      source_path = File.join(path, 'swagger.yaml')
      return source_path if File.exist? source_path
      return nil
    end
  end
end
