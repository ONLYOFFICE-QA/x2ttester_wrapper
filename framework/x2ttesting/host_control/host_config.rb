# frozen_string_literal: true

module X2tTesting
  # Specific configuration host for running x2t
  class HostConfig

    def initialize(dyld_library_path)
      @dyld_library_path = dyld_library_path
    end

    # Settings for running x2t on macOS
    # DYLD_LIBRARY_PATH environment variable is needed to start x2t correctly from any folder
    # @return [Hash] macOS configuration list: os, arch, x2t, converter, standardtester
    def mac_configuration
      ENV['DYLD_LIBRARY_PATH'] = @dyld_library_path
      {
        os: 'mac',
        arch: Gem::Platform.local.cpu.sub('arm64', 'arm'),
        x2t: 'x2t',
        x2ttester: 'x2ttester',
        standardtester: 'standardtester'
      }.freeze
    end

    # Settings for running x2t on windows
    # @return [Hash] windows configuration list: os, arch, x2t, converter, standardtester
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
    # @return [Hash] linux configuration list: os, arch, x2t, converter, standardtester
    def linux_configuration
      {
        os: 'linux',
        arch: Gem::Platform.local.cpu.sub('86_', ''),
        x2t: 'x2t',
        x2ttester: 'x2ttester',
        standardtester: 'standardtester'
      }.freeze
    end

    # Returns the names of x2t utilities
    # @return [Hash] host configuration list os, arch, x2t, converter, standardtester
    def os_specific_configuration
      case Gem::Platform.local.os
      when 'linux' then linux_configuration
      when 'darwin' then mac_configuration
      when 'mingw' then windows_configuration
      else
        raise RedStandardError, 'Error: definition os'
      end
    end
  end
end
