# frozen_string_literal: true


module X2tTesting
  # class for actions with OnlyOffice core
  class Core
    # @param [JSON] config_json - custom configuration file required core host url
    # @param [Hash] options is a hash with required keys:
    # :tmp_dir - is a path to tmp folder
    # :x2t_dir - is a path to folder with x2t
    def initialize(config_json, options = {})
      @core_host_url = config_json.fetch('core_host_url')
      @version = config_json.fetch('version')
      @tmp_dir = options[:tmp_dir]
      @x2t_dir = options[:x2t_dir]
      FileUtils.mkdir(@tmp_dir) unless Dir.exist?(@tmp_dir)
    end

    # Downloading and configures the core
    # @return [Object]
    def get
      headers = FileActions.get_headers(url)
      check_core_is_up_to_date(headers['last-modified'][0])
      download_core
      FileActions.unpacking_7z(File.join(@tmp_dir, File.basename(url)), @x2t_dir, delete: true)
      FileActions.fix_double_folder(@x2t_dir)
      write_core_date(headers['last-modified'][0])
      change_core_access
      File.write(File.join(@x2t_dir, 'DoctRenderer.config').to_s, x2t_libs_xml.doc_renderer_config)
      OnlyofficeLoggerHelper.green_log('DoctRenderer.config created')
    end

    private

    def host
      @host ||= HostConfig.new(@x2t_dir).os_specific_configuration
    end

    def x2t_libs_xml
      @x2t_libs_xml ||= X2tLibsXml.new
    end

    def url
      @url ||= CoreUrlGenerator.new(@core_host_url, @version, host[:os], host[:arch]).url
    end

    # Changes the access parameters of the folder and core components, to run on mac and linux
    def change_core_access
      return if host[:os].include?('windows')

      FileUtils.chmod('+x', Dir.glob("#{@x2t_dir}/*"))
    end

    # Writes the date of core creation to the core.data file
    # @param [String] core_data the date of core creation
    def write_core_date(core_data)
      File.write(File.join(@x2t_dir, 'core.data'), core_data)
    end

    # Reads the previously recorded date of the core creation from the file
    # @return [String] The date of creation of the existing core
    def read_core_data
      return '' unless File.exist?(File.join(@x2t_dir, 'core.data'))

      File.read(File.join(@x2t_dir, 'core.data'))
    end

    # Checks that the current core version is up to date
    # @param [String] core_data the date of core creation
    def check_core_is_up_to_date(core_data)
      existing_core_data = read_core_data
      return unless core_data == existing_core_data && existing_core_data != '' && core_data != ''

      raise RedStandardError, 'Core Already up-to-date'
    end

    # Downloads the core
    def download_core
      FileUtils.rm_rf(@x2t_dir)
      OnlyofficeLoggerHelper.green_log("Downloading core\nversion: #{@version}\nOS: #{host[:os]}\nURL: #{url}")
      FileActions.download_file(url, File.join(@tmp_dir, File.basename(url)))
      OnlyofficeLoggerHelper.green_log('Download completed')
    end
  end
end
