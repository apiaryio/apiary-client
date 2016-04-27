require 'spec_helper'

describe Apiary::Command::Preview do

  let(:command) do
    opts = {
      path: "#{File.expand_path File.dirname(__FILE__)}/../../../features/fixtures/apiary.apib"
    }
    Apiary::Command::Preview.new(opts)
  end

  it 'check tmp path if contains filename' do
    expect(command.preview_path()).to end_with('apiary-preview.html')
  end

  it 'shoud contain html5 doctype' do
    expect(command.generate()).to include('<!DOCTYPE html>')
  end

  it 'should contain embed javascript' do
    expect(command.generate()).to include('https://api.apiary.io/seeds/embed.js')
  end

end
