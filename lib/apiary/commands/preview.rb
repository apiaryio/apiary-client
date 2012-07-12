# encoding: utf-8

# Usage:
#   apiary preview
#   apiary preview my_apib_file.apib
#   apiary preview [my_apib_file.apib] --api_host=api.apiary.io
#   apiary preview [my_apib_file.apib] --browser=Safari

# Display preview of local blueprint file
Task.new(:preview) do |task|
  task.description = "Display preview of local blueprint file"

  # Configuration.
  task.config[:apib_file] = "#{File.basename(Dir.pwd)}.apib"
  task.config[:api_host]  = "api.apiary.io"
  task.config[:headers]   = {accept: "text/html", content_type: "text/plain"}
  task.config[:browser]   = "Google Chrome"

  task.boot do
    require "rest_client"
  end

  # Singleton methods.
  def task.validate_apib_file(apib_file)
    unless File.exist?(apib_file)
      abort "Apiary definition file hasn't been found: #{apib_file.inspect}"
    end
  end

  def browser(options)
    options[:browser] || self.config[:browser]
  end

  def api_host(options)
    options[:api_host] || self.config[:api_host]
  end

  def resolve_apib_file(apib_file)
    apib_file = apib_file || self.config[:apib_file]
  end

  # The actual definition.
  task.define do |apib_file, options|
    apib_file = self.resolve_apib_file(apib_file)

    self.validate_apib_file(apib_file)

    url = "https://#{self.api_host(options)}/blueprint/generate"
    apib = IO.read(apib_file)
    response = RestClient.post(url, apib, self.config[:headers])

    basename = File.basename(apib_file)
    File.open("/tmp/#{basename}-preview.html", "w") do |file|
      file.write(response)
      # TODO: Support non OS X systems again. Could be done
      # through launchy or similar projects, but launchy seemed
      # to be tad buggy to me (ignored application I wanted to use),
      # so for now it's done through the open command.
      sh "open -a '#{self.browser(options)}' '#{file.path}'"
    end
  end
end

# Task.tasks.default_proc = lambda { |*| Task[:preview] }
