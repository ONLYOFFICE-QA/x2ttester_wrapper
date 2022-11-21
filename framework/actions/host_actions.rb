# frozen_string_literal: true

# Getting information's about host
class HostActions

  # Settings for running x2t on macOS
  # DYLD_LIBRARY_PATH environment variable is needed to start x2t correctly from any folder
  def self.mac_configuration
    ENV['DYLD_LIBRARY_PATH'] = StaticData::CORE_DIR.to_s
  end

  # Returns the names of x2t utilities and information about the OS
  # @return [[String, String, String, String, String]] os, arch, x2t, x2ttester, standardtester
  def self.host_validations
    case Gem::Platform.local.os
    when 'linux'
      ['linux', Gem::Platform.local.cpu.sub('86_', ''), 'x2t', 'x2ttester', 'standardtester']
    when 'darwin'
      HostActions.mac_configuration
      ['mac', Gem::Platform.local.cpu.sub('arm64', 'arm'), 'x2t', 'x2ttester', 'standardtester']
    when 'mingw'
      ['windows', Gem::Platform.local.cpu, 'x2t.exe', 'x2ttester.exe', 'standardtester.exe']
    else
      p 'Error: definition os'
    end
  end
end
