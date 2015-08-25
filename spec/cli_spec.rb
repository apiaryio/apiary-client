require 'spec_helper'

describe Apiary::CLI do

  it 'has help' do
    helpcount = Kernel.open('|bin/apiary help') {|f| f.read}.lines.count
    expect(helpcount).to be >= 5
  end

  ['', 'fetch ', 'preview ', 'publish ', 'version '].each do |cmd|
    it "includes help #{cmd}in README.md" do
      begin
        helpfile='help.out'
        helptext = open("|bin/apiary help #{cmd} | tee #{helpfile}") {|f| f.read}
        matchtext = `diff -w -C1000 README.md #{helpfile} | sed -n '/^  \\(.*\\)/s//\\1/p'`

        expect(matchtext).to eq(helptext)

      ensure
        !File.exist?(helpfile) || File.unlink(helpfile)
      end
    end
  end

end
