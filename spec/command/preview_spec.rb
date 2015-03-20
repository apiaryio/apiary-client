require 'spec_helper'

describe Apiary::Command::Preview do

  it 'check tmp path if contains filename' do
    opts = {}
    command = Apiary::Command::Preview.new(opts)
    expect(command.preview_path('apiary.apib')).to end_with('apiary.apib-preview.html')
  end

end
