# frozen_string_literal: true

# Getting information's about host
class HostConfig
  # Returns the names of x2t utilities and information about the OS
  # @return [[String, String, String, String, String]] os, arch, x2t, x2ttester, standardtester
  def self.host_information
    case Gem::Platform.local.os
    when 'linux'
      ['linux', Gem::Platform.local.cpu.sub('86_', ''), 'x2t', 'x2ttester', 'standardtester']
    when 'darwin'
      ['mac', Gem::Platform.local.cpu.sub('arm', 'x'), 'x2t', 'x2ttester', 'standardtester']
    when 'mingw'
      ['windows', Gem::Platform.local.cpu, 'x2t.exe', 'x2ttester.exe', 'standardtester.exe']
    else
      p 'Error: definition os'
    end
  end
end

