require 'spec_helper'

describe Apiary::CLI do

  it 'has help' do
    helpcount = Kernel.open('|bin/apiary help') {|f| f.read}.lines.count
    expect(helpcount).to be >= 5
  end
  
  it 'includes help in README.md' do

    begin
      helpcount = Kernel.open('|bin/apiary help | tee help.out') {|f| f.read}.lines.count
      expect(helpcount).to be >= 5 

      matchcount = `diff -w -C1000 README.md help.out | grep '^ '`.lines.count
      expect(matchcount).to eq(helpcount)

    ensure
      File.unlink('help.out')
    end

  end

end
