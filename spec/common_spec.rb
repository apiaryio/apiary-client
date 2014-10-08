require 'spec_helper'

describe Apiary::Common do

  describe 'Validate apib files' do

    it 'test existing file' do
      common = Apiary::Common.new
      expect(common.validate_apib_file('features/fixtures/apiary.apib')).to be_truthy
    end

    it 'test non existing file' do
      common = Apiary::Common.new
      expect {common.validate_apib_file('features/fixtures/apiary.xxx')}.to raise_error(/file hasn't been found/)
    end

  end

  describe 'Validate blueprint' do

    it 'test validate blueprint' do
      common = Apiary::Common.new
      expect(common.validate_blueprint('# API_NAME')).to be_truthy
    end

    it 'test invalidate blueprint' do
      common = Apiary::Common.new
      expect(common.validate_blueprint("\t# API_NAME\t\r\n## Group Name")).to be_falsey
    end

  end

end
