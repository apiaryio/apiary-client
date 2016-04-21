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

  describe 'Test get file with and without BOM' do

    it 'get file and compare' do
      common = Apiary::Common.new
      file1 = common.get_apib_file('features/fixtures/apiary.apib')
      file2 = common.get_apib_file('features/fixtures/apiary_with_bom.apib')
      expect(file1).to eq(file2)
    end
  end

  describe 'Test user_agent' do

    it 'get agent' do
      expect(Apiary::USER_AGENT).to start_with("apiaryio-gem/#{Apiary::VERSION}")
    end
  end

end
