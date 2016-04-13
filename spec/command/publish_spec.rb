require 'spec_helper'

describe Apiary::Command::Publish do
  context 'when constructed without a message' do
    it 'uses the default message' do
      command = Apiary::Command::Publish.new({})
      expect(command.options.message).to eq('Saving blueprint from apiary-client')
    end
  end

  context 'when constructed with a message' do
    it 'stores the message in the opts' do
      command = Apiary::Command::Publish.new(:message => 'Custom message')
      expect(command.options.message).to eq('Custom message')
    end
  end

  describe '#execute' do
    context 'when calling with a custom message' do
      it 'sends the message when publishing' do
        WebMock.stub_request(:post, 'https://api.apiary.io/blueprint/publish/myapi')
        Apiary::Command::Publish.new(:api_name => 'myapi', :message => 'Custom message').execute
        expect(WebMock).to have_requested(:post, 'https://api.apiary.io/blueprint/publish/myapi').
          with {|request| request.body.include? 'messageToSave=Custom%20message'}
      end
    end
  end
end
