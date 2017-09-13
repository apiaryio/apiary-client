Then(/^the output should contain the content of file "(.*)"$/) do |filename|
  expected = nil
  cd('../../features/support') do
    expected = File.read(filename)
  end

  actual = all_commands.map(&:output).join("\n")

  expect(unescape_text(actual)).to include(unescape_text(expected))
end
