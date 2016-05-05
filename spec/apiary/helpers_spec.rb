require 'spec_helper'

describe Apiary::Helpers do
  include Apiary::Helpers

  describe '#api_description_source_path' do
    context 'path doesn\'t exists' do
      it 'should raise error saying that Directory doesn\'t exists' do
        path = 'spec/fixtures/invalid_path'
        expect { api_description_source_path(path)}.to raise_error(/Invalid path/)
      end
    end

    context 'missing file is in path' do
      it 'should raise error saying that file doesn\'t exists' do
        path = 'spec/fixtures/only_api_blueprint/swagger.yaml'
        expect { api_description_source_path(path)}.to raise_error(/Invalid path/)
      end
    end

    context 'directory is in path and contains API Blueprint only' do
      it 'should return path ending to `apiary.apib`' do
        path = 'spec/fixtures/only_api_blueprint'
        expect(api_description_source_path(path)).to match(/apiary\.apib$/)
      end
    end

    context 'directory is in path and contains Swagger only' do
      it 'should return path ending to `swagger.yaml`' do
        path = 'spec/fixtures/only_swagger'
        expect(api_description_source_path(path)).to match(/swagger\.yaml$/)
      end
    end

    context 'directory is in path and contains both API Blueprint and Swagger' do
      it 'should prefere API Blueprint and return path ending to `apiary.apib`' do
        path = 'spec/fixtures/api_blueprint_and_swagger'
        expect(api_description_source_path(path)).to match(/apiary\.apib$/)
        expect { api_description_source_path(path) }.to output("WARNING: Both apiary.apib and swagger.yaml are present. The apiary.apib file will be used. To override this selection specify path to desired file\n").to_stderr
      end
    end

    context 'empty folder' do
      it 'should raise error saying that file doesn\'t exists' do
        path = 'spec/fixtures/empty_folder'
        expect { api_description_source_path(path)}.to raise_error('No API Description Document found')
      end
    end

    context 'existing file is in path' do
      it 'should return same path as was entered' do
        path = 'spec/fixtures/only_api_blueprint/apiary.apib'
        expect(api_description_source_path(path)).to equal(path)
      end
    end
  end

  describe '#api_description_source' do
    it 'get file with and without BOM' do
      file1 = api_description_source('spec/fixtures/apiary.apib')
      file2 = api_description_source('spec/fixtures/apiary_with_bom.apib')
      expect(file1).not_to be_nil
      expect(file2).not_to be_nil
      expect(file1).to eq(file2)
    end
  end
end
