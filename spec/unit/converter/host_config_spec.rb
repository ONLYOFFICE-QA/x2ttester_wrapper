# frozen_string_literal: true

require 'rspec'

require_relative '../../../framework/manager_x2ttesting'

describe X2tTesting::HostConfig, type: :aruba do
  tmp_dir = "#{Dir.pwd}/tmp"
  host = described_class.new(tmp_dir).os_specific_configuration
  x2ttester = Gem::Platform.local.os == 'mingw' ? 'x2ttester.exe' : 'x2ttester'
  x2t = Gem::Platform.local.os == 'mingw' ? 'x2t.exe' : 'x2t'
  standardtester = Gem::Platform.local.os == 'mingw' ? 'standardtester.exe' : 'standardtester'

  it 'Check of x2tteser specific configuration ' do
    expect(host[:x2ttester]).to eq(x2ttester)
    expect(host[:x2t]).to eq(x2t)
    expect(host[:standardtester]).to eq(standardtester)
  end
end