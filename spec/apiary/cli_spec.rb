require 'spec_helper'

describe Apiary::CLI do
  # Don't let Thor fold or truncate lines
  ENV['THOR_COLUMNS'] = '1000'

  # The documentation that ought to match the code
  READMETEXT = open('README.md', &:read)

  it 'has help' do
    help = open('|ruby bin/apiary help', &:read)
    expect(help).to include('Commands:')
    expect(help.lines.count).to be >= 5
  end

  it 'has README.md' do
    expect(READMETEXT).to include('apiary help')
    expect(READMETEXT.lines.count).to be >= 5
  end

  # Confirm that all subcommands are documented, verbatim
  ([''] + (open('|ruby bin/apiary help', 'r', &:readlines)
            .map { |l| /^ +apiary / =~ l ? l : nil }
            .map { |l| /^ *apiary help/ =~ l ? nil : l }
            .compact
            .map { |l| /^ *apiary ([^ ]*)/.match(l)[1] + ' ' }
          )
  ).each do |cmd|
    it "includes help #{cmd}in README.md" do
      puts cmd
      helptext = open("|ruby bin/apiary help #{cmd}", &:read)

      expect(helptext).to include("apiary #{cmd.strip}")
      expect(READMETEXT).to include("apiary #{cmd.strip}")
      expect(READMETEXT).to include(helptext)
    end
  end
end
