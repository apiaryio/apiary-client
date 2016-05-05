require 'spec_helper'

describe Apiary::Command::Publish do
  context 'when constructed without a message' do
    let(:message) do
      Apiary::Command::Publish.new({
        :api_name => 'myapi',
        :path => 'spec/fixtures/apiary.apib',
        :api_key => 'testkey'
      }).options.message
    end

    it 'uses the default message' do
      expect(message).to eq('Saving API Description from apiary-client')
    end
  end

  context 'when constructed with a message' do
    let(:message) do
      Apiary::Command::Publish.new({
        :api_name => 'myapi',
        :message => 'Custom message',
        :path => 'spec/fixtures/apiary.apib',
        :api_key => 'testkey'
      }).options.message
    end

    it 'stores the message in the opts' do
      expect(message).to eq('Custom message')
    end
  end

  describe '#execute' do
    context 'when calling with a custom message' do
      before(:all) do
        WebMock.stub_request(:post, 'https://api.apiary.io/blueprint/publish/myapi')
        Apiary::Command::Publish.new({
          :api_name => 'myapi',
          :message => 'Custom message',
          :path => 'spec/fixtures/apiary.apib',
          :api_key => 'testkey'
        }).execute
      end

      it 'sends the message when publishing' do
        expect(WebMock).to have_requested(:post, 'https://api.apiary.io/blueprint/publish/myapi').
          with {|request| request.body.include? 'messageToSave=Custom%20message'}
      end
    end
  end
end
