require 'spec_helper'

describe Apiary::CLI do

  it 'has help' do
    helpcount = Kernel.open('|bin/apiary help') {|f| f.read}.lines.count
    expect(helpcount).to be >= 5
  end

  (["",] +
   `bin/apiary help`
     .lines
     .map {|l| /^ +apiary /.match(l)?l:nil}
     .map {|l| /^ *apiary help/.match(l)?nil:l}
     .compact
     .map {|l| /^ *apiary ([^ ]*)/.match(l)[1] + " " }
  ).each do |cmd|

    it "includes help #{cmd}in README.md" do
      begin
        helpfile="help#{cmd.strip}.out"
        helptext = open("|bin/apiary help #{cmd} | tee #{helpfile}") {|f| f.read}
        matchtext = `diff -w -C1000 README.md #{helpfile} | sed -n '/^  \\(.*\\)/s//\\1/p'`

        expect(matchtext).to eq(helptext)

      ensure
        !File.exist?(helpfile) || File.unlink(helpfile)
      end
    end
  end

end
