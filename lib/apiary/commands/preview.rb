# encoding: utf-8

# Usage:
#   apiary preview
#   apiary preview my_apib_file.apib
#   apiary preview [my_apib_file.apib] --api_host=api.apiary.io
#   apiary preview [my_apib_file.apib] --browser=chrome
#   apiary preview [my_apib_file.apib] --server
#   apiary preview [my_apib_file.apib] --server --port=8010

# Display preview of local blueprint file

require "rest_client"

Nake::Task.new(:preview) do |task|
  BROWSERS ||= {
    safari: "Safari",
    chrome: "Google Chrome",
    firefox: "Firefox"
  }

  task.description = "Display preview of local blueprint file"

  # Configuration.
  task.config[:apib_path] = nil
  task.config[:api_host]  = "api.apiary.io"
  task.config[:headers]   = {accept: "text/html", content_type: "text/plain"}
  task.config[:browser]   = "Google Chrome"
  task.config[:port]      = 8080

  # Singleton methods.
  def validate_apib_file(apib_file)
    unless File.exist?(apib_file)
      abort "Apiary definition file hasn't been found: #{apib_file.inspect}"
    end
  end

  def default_apib_path
    self.config[:apib_path] || "#{File.basename(Dir.pwd)}.apib"
  end

  def browser(options)
    BROWSERS[options[:browser]] || options[:browser] || BROWSERS[self.config[:browser]] || self.config[:browser]
  end

  def api_host(options)
    options[:api_host] || self.config[:api_host]
  end

  def port(options)
    options[:port] || config[:port]
  end

  def rack_app(&block)
    Rack::Builder.new do
      run lambda { |env| [200, Hash.new, [block.call]] }
    end
  end

  def run_server(apib_path, options)
    require "rack"

    port = self.port(options)

    app = self.rack_app do
      host = self.api_host(options)
      self.query_apiary(host, apib_path)
    end

    Rack::Server.start(Port: port, app: app)
  rescue LoadError
    puts "If you want to run the server, you need rack:"
    puts
    puts "  gem install rack"
    exit 1
  end

  def preview_path(apib_path)
    basename = File.basename(apib_path)
    "/tmp/#{basename}-preview.html"
  end

  def query_apiary(host, apib_path)
    url  = "https://#{host}/blueprint/generate"
    data = File.read(apib_path)
    RestClient.post(url, data, self.config[:headers])
  end

  def open_generated_page(path, options)
    sh "open -a '#{self.browser(options)}' '#{path}'"
  end

  # TODO: Support non OS X systems again. Could be done
  # through launchy or similar projects, but launchy seemed
  # to be tad buggy to me (ignored application I wanted to use),
  # so for now it's done through the open command.
  def generate_static(apib_path, options)
    File.open(self.preview_path(apib_path), "w") do |file|
      file.write(self.query_apiary(self.api_host(options), apib_path))
      self.open_generated_page(file.path, options)
    end
  end

  # The actual definition.
  task.define do |apib_path = default_apib_path, options|
    self.validate_apib_file(apib_path)

    if options[:server]
      self.run_server(apib_path, options)
    else
      self.generate_static(apib_path, options)
    end
  end
end
