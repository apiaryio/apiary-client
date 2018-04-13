require 'spec_helper'

def test_abort(command, message)
  expect do
    begin
      command.execute
    rescue SystemExit
    end
  end.to output(/#{message}/).to_stderr
end

describe Apiary::Command::Styleguide do
  describe 'fetch' do
    it 'call command without APIARY_API_KEY set' do
      opts = {
        fetch: true,
        api_key: ''
      }
      command = Apiary::Command::Styleguide.new(opts)
      test_abort(command, 'Error: API key must be provided through environment variable APIARY_API_KEY.')
    end

    it 'call command with incorrect APIARY_API_KEY' do
      opts = {
        fetch: true,
        api_key: 'xxx'
      }

      command = Apiary::Command::Styleguide.new(opts)
      stub_request(:get, "https://#{command.options.api_host}/styleguide-cli/get-assertions/").to_return(status: [403, 'This resource requires authenticated API call.'])

      test_abort(command, 'Error: Apiary service responded with: 403')
    end

    it 'call command with correct APIARY_API_KEY' do
      opts = {
        fetch: true,
        api_key: 'xxx'
      }

      command = Apiary::Command::Styleguide.new(opts)

      body = '{"rules":{"_id":"598af267b999bef906c10ef8","organisation":"5577dbc613036160198734cf","createdAt":"2017-08-22T12:57:05.123Z","rules":[{"intent":"validateApiName","target":"API_Name","functionName":"validateApiName","ruleName":"validateApiName"}]},"functions":{"_id":"598af267b999bef906c10ef9","organisation":"5577dbc613036160198734cf","language":"JavaScript","functions":"/*\r\n @targets: API_Name\r\n */\r\n\r\nfunction validateApiName(apiName) {\r\n    return true;\r\n};\r\n"}}'
      stub_request(:get, "https://#{command.options.api_host}/styleguide-cli/get-assertions/").to_return(status: 200, body: body)

      expect do
        begin
          command.execute
        rescue SystemExit
        end
      end.to output("`./functions.js` and `./rules.json` has beed succesfully created\n").to_stdout

      assertions = JSON.parse(body)

      functions = nil
      File.open('./functions.js', 'r:bom|utf-8') { |file| functions = file.read }
      rules = nil
      File.open('./rules.json', 'r:bom|utf-8') { |file| rules = file.read }

      expect(assertions['functions']['functions']).to eq(functions)
      expect(JSON.pretty_generate(assertions['rules']['rules'])).to eq(rules)
    end
  end

  describe 'validate' do
    it 'call command without APIARY_API_KEY set' do
      opts = {
        api_key: ''
      }
      command = Apiary::Command::Styleguide.new(opts)
      expect do
        command.execute
      end.to raise_error(SystemExit)

      test_abort(command, 'Error: API key must be provided through environment variable APIARY_API_KEY')
    end

    it 'call command with incorrect APIARY_API_KEY' do
      opts = {
        api_key: 'xxx'
      }

      command = Apiary::Command::Styleguide.new(opts)
      stub_request(:get, "https://#{command.options.api_host}/styleguide-cli/get-token/").to_return(status: 403)

      test_abort(command, 'Error: Apiary service responded with: 403')
    end

    it 'call command with incorrect ADD path' do
      opts = {
        api_key: 'xxx',
        functions: 'features/support',
        rules: 'features/support',
        add: 'features/supportXXX'
      }

      command = Apiary::Command::Styleguide.new(opts)
      stub_request(:get, "https://#{command.options.api_host}/styleguide-cli/get-token/").to_return(status: 200, body: '{"jwt":"xxx"}')

      test_abort(command, 'Invalid path features/supportXXX')
    end

    it 'call command with incorrect functions path' do
      opts = {
        api_key: 'xxx',
        functions: 'features/supportXXY',
        rules: 'features/support',
        add: 'features/support'
      }

      command = Apiary::Command::Styleguide.new(opts)
      stub_request(:get, "https://#{command.options.api_host}/styleguide-cli/get-token/").to_return(status: 200, body: '{"jwt":"xxx"}')

      test_abort(command, 'supportXXY` not found')
    end

    it 'call command with incorrect rules path' do
      opts = {
        api_key: 'xxx',
        functions: 'features/support',
        rules: 'features/supportsupportXXZ',
        add: 'features/support'
      }

      command = Apiary::Command::Styleguide.new(opts)
      stub_request(:get, "https://#{command.options.api_host}/styleguide-cli/get-token/").to_return(status: 200, body: '{"jwt":"xxx"}')

      test_abort(command, 'supportXXZ` not found')
    end

    it 'call command with correct options which should fail' do
      opts = {
        api_key: 'xxx',
        functions: 'features/support/functions-fail.js',
        rules: 'features/support',
        add: 'features/support',
        full_report: true
      }

      command = Apiary::Command::Styleguide.new(opts)
      stub_request(:get, "https://#{command.options.api_host}/styleguide-cli/get-token/").to_return(status: 200, body: '{"jwt":"xxx"}')
      response = '[{"ruleName":"validateApiName","functionName":"validateApiName","target":"API_Name","intent":"validateApiName","code":"function validateApiName(apiName) {\n    return \'fail\';\n}","functionComment":"\n @targets: API_Name\n ","allowedPaths":["API_Name"],"ref":["API_Name-0"],"results":[{"validatorError":false,"result":"fail","path":"API_Name-0","data":"test","sourcemap":[[12,7]],"sourcemapLines":{"start":2,"end":2}}]}]'
      stub_request(:post, command.options.vk_url).to_return(status: 200, body: response)

      expect do
        begin
          command.execute
        rescue SystemExit
        end
      end.to output("\n    validateApiName\n      [❌] FAILED: API_Name #0 on line 2 - `fail`\n\n").to_stdout
    end

    it 'call command with correct options and json output' do
      opts = {
        api_key: 'xxx',
        functions: 'features/support',
        rules: 'features/support',
        add: 'features/support',
        full_report: true,
        json: true
      }

      command = Apiary::Command::Styleguide.new(opts)
      stub_request(:get, "https://#{command.options.api_host}/styleguide-cli/get-token/").to_return(status: 200, body: '{"jwt":"xxx"}')
      stub_request(:post, command.options.vk_url).to_return(status: 200, body: '[]')

      expect do
        begin
          command.execute
        rescue SystemExit
        end
      end.to output("[\n\n]\n").to_stdout
    end
  end

  describe 'push' do
    it 'call command without APIARY_API_KEY set' do
      opts = {
        push: true,
        api_key: '',
        functions: 'features/support',
        rules: 'features/support'
      }
      command = Apiary::Command::Styleguide.new(opts)
      test_abort(command, 'Error: API key must be provided through environment variable APIARY_API_KEY.')
    end

    it 'call command with incorrect APIARY_API_KEY' do
      opts = {
        push: true,
        api_key: 'xxx'
      }

      command = Apiary::Command::Styleguide.new(opts)
      stub_request(:post, "https://#{command.options.api_host}/styleguide-cli/set-assertions/").to_return(status: [403, 'This resource requires authenticated API call.'])

      test_abort(command, 'Error: Apiary service responded with: 403')
    end

    it 'call command with correct APIARY_API_KEY' do
      opts = {
        push: true,
        api_key: 'xxx',
        functions: 'function testFunction(data) { return "failed"; }',
        rules: '[{"ruleName": "testName","functionName": "testFunction","target": "Request_Body","intent": "testIntent"}]'
      }

      command = Apiary::Command::Styleguide.new(opts)
      stub_request(:post, "https://#{command.options.api_host}/styleguide-cli/set-assertions/").to_return(status: 200, body: '')

      expect do
        begin
          command.execute
        rescue SystemExit
        end
      end.to output('').to_stdout
    end
  end
end
