Then /^the output should contain the content of file "(.*)"$/ do |filename|
  expected = nil
  in_current_dir do
    expected = File.read(filename)
  end

  assert_partial_output(expected, all_output)
end


Then /^output file "(.*)" should contain the content of file "(.*)"$/ do |input, output|
  expected = nil
  in_current_dir do
    actual = File.read(input)
    expected = File.read(output)
  end

  assert_partial_output(expected, actual)
end
