# frozen_string_literal: true

module X2tTesting
  # class for getting OnlyOffice core information from the aws server
  class CoreUrlGenerator

    attr_reader :url, :build, :branch, :branch_version

    def initialize(core_host_url, version, os, arch)
      @version = version_correct?(version)
      @core_host_url = delete_last_slash(core_host_url)
      @os = os
      @arch = arch
      @build = generate_build(@version)
      @branch = generate_branch
      @branch_version = generate_url_version
      @url = generate_url
    end

    private

    def delete_last_slash(string)
      return string.strip.chop! if %w[/ \\].include? string.strip.chars[-1]

      string
    end

    # Checks if the version entered in config.json is correct
    # @param [String] version
    def version_correct?(version)
      return version if version.split('.').length == 4

      raise RedStandardError 'check the version correctness in config.json, the version must be in the format "x.x.x.x"'
    end

    # generates the url for the core download
    def generate_url
      if @branch == 'develop'
        "#{@core_host_url}/repo-doc-onlyoffice-com/#{@os}/core/#{@branch}/#{@build}/#{@arch}/core.7z"
      else
        "#{@core_host_url}/repo-doc-onlyoffice-com/#{@os}/core/#{@branch}/#{@branch_version}/#{@build}/#{@arch}/core.7z"
      end
    end

    # @return [String] Generated branch for url
    def generate_branch
      return 'develop' if @version.include?('99.99.99')
      # return hotfix if the third value is not 0
      return 'hotfix' if @version.match(/\A\d+\.\d+\.(\d+)\.\d+\z/)[1].to_i != 0

      'release'
    end

    # @return [String] Generated version core for url
    def generate_url_version
      "v#{@version}".sub(/.*\K\..*/, '') # Cuts the last value from the full version
    end

    # @return [String] Generated build for url
    def generate_build(version)
      return version if @os.include?('windows')

      version.sub(/.*\K\./, '-') # Changes the third point to '-'
    end
  end
end
