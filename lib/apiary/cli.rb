# encoding: utf-8

require 'thor'
require 'apiary/command/fetch'
require 'apiary/command/archive'
require 'apiary/command/preview'
require 'apiary/command/publish'
require 'apiary/command/styleguide'

module Apiary
  class CLI < Thor

    desc 'archive', 'Archive All Your API Description Documents from apiary.io to local files named following [api-project-subdomain.apib] pattern.'
    method_option :api_host, type: :string, banner: 'HOST', desc: 'Specify apiary host', hide: true

    def archive
      cmd = Apiary::Command::Archive.new options
      cmd.execute
    end

    desc 'fetch', 'Fetch API Description Document from API_NAME.docs.apiary.io'
    method_option :api_name, type: :string, required: true
    method_option :api_host, type: :string, banner: 'HOST', desc: 'Specify apiary host', hide: true
    method_option :output, type: :string, banner: 'FILE', desc: 'Write API Description Document into specified file'

    def fetch
      cmd = Apiary::Command::Fetch.new options
      cmd.execute
    end

    desc 'preview', 'Show API documentation in browser or write it to file'
    method_option :browser, type: :string, desc: 'Show API documentation in specified browser (full command is needed - e.g. `--browser=\'open -a safari\'` in case of osx)'
    method_option :output, type: :string, banner: 'FILE', desc: 'Write generated HTML into specified file'
    method_option :path, type: :string, desc: 'Specify path to API Description Document. When given a directory, it will look for `apiary.apib` and `swagger.yaml` file'
    method_option :json, type: :boolean, desc: 'Specify that Swagger API Description Document is in json format. Document will be converted to yaml before processing'
    method_option :api_host, type: :string, banner: 'HOST', desc: 'Specify apiary host', hide: true
    method_option :server, type: :boolean, desc: 'Start standalone web server on port 8080'
    method_option :port, type: :numeric, banner: 'PORT', desc: 'Set port for --server option'
    method_option :host, type: :string, desc: 'Set host for --server option'
    method_option :watch, type: :boolean, desc: 'Reload API documentation when API Description Document has changed'

    def preview
      cmd = Apiary::Command::Preview.new options
      cmd.execute
    end

    desc 'publish', 'Publish API Description Document on API_NAME.docs.apiary.io (API Description must exist on apiary.io)'
    method_option :message, type: :string, banner: 'COMMIT_MESSAGE', desc: 'Publish with custom commit message'
    method_option :path, type: :string, desc: 'Specify path to API Description Document. When given a directory, it will look for `apiary.apib` and `swagger.yaml` file'
    method_option :json, type: :boolean, desc: 'Specify that Swagger API Description Document is in json format. Document will be converted to yaml before processing'
    method_option :api_host, type: :string, banner: 'HOST', desc: 'Specify apiary host', hide: true
    method_option :push, type: :boolean, default: true, desc: 'Push API Description to the GitHub when API Project is associated with GitHub repository in Apiary'
    method_option :api_name, type: :string, required: true

    def publish
      cmd = Apiary::Command::Publish.new options
      cmd.execute
    end

    desc 'styleguide', 'Check API Description Document against styleguide rules (Apiary.io pro plan is required - https://apiary.io/plans )'
    method_option :fetch, type: :boolean, desc: 'Fetch styleguide rules and functions from apiary.io'
    method_option :push, type: :boolean, desc: 'Push styleguide rules and functions to apiary.io'
    method_option :add, type: :string, desc: 'Path to API Description Document. When given a directory, it will look for `apiary.apib` and `swagger.yaml` file'
    method_option :functions, type: :string, desc: 'Path to to the file with functions definitions'
    method_option :rules, type: :string, desc: 'Path to to the file with rules definitions - `functions.js` and `rules.json` are loaded if not specified'
    method_option :full_report, type: :boolean, default: false, desc: 'Get passed assertions ass well. Only failed assertions are included to the result by default'
    method_option :json, type: :boolean, default: false, desc: 'Outputs all in json'
    def styleguide
      cmd = Apiary::Command::Styleguide.new options
      cmd.execute
    end

    desc 'version', 'Show version'
    method_option aliases: '-v'

    def version
      puts Apiary::VERSION
    end
  end
end
