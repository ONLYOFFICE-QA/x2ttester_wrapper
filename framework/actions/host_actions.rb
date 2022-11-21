# frozen_string_literal: true

# Getting information's about host
class HostActions
  # Settings for running x2t on macOS
  # DYLD_LIBRARY_PATH environment variable is needed to start x2t correctly from any folder
  # @return [Hash] macOS configuration list: os, arch, x2t, x2ttester, standardtester
  def mac_configuration
    ENV['DYLD_LIBRARY_PATH'] = ProjectConfig.core_dir
    {
      os: 'mac',
      arch: Gem::Platform.local.cpu.sub('arm64', 'arm'),
      x2t: 'x2t',
      x2ttester: 'x2ttester',
      standardtester: 'standardtester'
    }.freeze
  end

  # Settings for running x2t on windows
  # @return [Hash] windows configuration list: os, arch, x2t, x2ttester, standardtester
  def windows_configuration
    {
      os: 'windows',
      arch: Gem::Platform.local.cpu,
      x2t: 'x2t.exe',
      x2ttester: 'x2ttester.exe',
      standardtester: 'standardtester.exe'
    }.freeze
  end

  # Settings for running x2t on linux
  # @return [Hash] linux configuration list: os, arch, x2t, x2ttester, standardtester
  def linux_configuration
    {
      os: 'linux',
      arch: Gem::Platform.local.cpu.sub('86_', ''),
      x2t: 'x2t',
      x2ttester: 'x2ttester',
      standardtester: 'standardtester'
    }.freeze
  end

  # Returns the names of x2t utilities and information about the OS
  # @return [Hash] host configuration list os, arch, x2t, x2ttester, standardtester
  def host_validations
    case Gem::Platform.local.os
    when 'linux'
      linux_configuration
    when 'darwin'
      mac_configuration
    when 'mingw'
      windows_configuration
    else
      raise('Error: definition os')
    end
  end
end
