Then /^the output should contain the content of file "(.*)"$/ do |filename|
  expected = nil
  cd('../../spec/fixtures') do
    expected = File.read(filename)
  end

  actual = all_commands.map { |c| c.output }.join("\n")

  expect(unescape_text(actual)).to include(unescape_text(expected))
end
