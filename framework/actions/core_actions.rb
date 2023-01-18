# frozen_string_literal: true

# class for actions with core
class CoreActions
  def initialize
    @x2ttester_config = ProjectConfig::CONFIG
    @os = ProjectConfig.host_config[:os]
    @arch = ProjectConfig.host_config[:arch]
    @version = generate_version
    @build = generate_build
    @branch = generate_branch
    @url = generate_url
    @core_archive = "#{ProjectConfig.tmp_dir}/#{File.basename(@url)}"
  end

  # @return [String] Generated branch for url
  def generate_branch
    return 'develop' if @x2ttester_config.fetch('version').include?('99.99.99')

    'release'
  end

  # @return [String] Generated version core for url
  def generate_version
    "v#{@x2ttester_config.fetch('version')}".sub(/.*\K\..*/, '')
  end

  # @return [String] Generated build for url
  def generate_build
    if @os.include?('windows')
      @x2ttester_config.fetch('version')
    else
      @x2ttester_config.fetch('version').sub(/.*\K\./, '-')
    end
  end

  # generates the url for the core download
  def generate_url
    host = 'https://s3.eu-west-1.amazonaws.com/repo-doc-onlyoffice-com'
    if @branch == 'develop'
      "#{host}/#{@os}/core/#{@branch}/#{@build}/#{@arch}/core.7z"
    else
      "#{host}/#{@os}/core/#{@branch}/#{@version}/#{@build}/#{@arch}/core.7z"
    end
  end

  # Generates a command to get information about the status of the core on the server
  def getting_core_status
    uri = URI.parse(@url)
    Net::HTTP.start(uri.hostname, uri.port, { use_ssl: uri.scheme == 'https' }) do |http|
      http.request(Net::HTTP::Head.new(uri))
    end
  end

  # Checks if the file exists on the server and checks validity of url
  # @return [String] Response from the server
  def check_core_on_server
    %w[release hotfix].unshift(@branch).uniq.each do |branch|
      if @branch != branch
        @branch = branch
        @url = generate_url
      end
      core_status = getting_core_status
      return core_status if core_status.code == '200'
    end

    raise(OnlyofficeLoggerHelper.red_log("Core not found\nURL: #{@url}\nResponse:\n#{getting_core_status}"))
  end

  # @param [String] archive_path Path to the archive to unpack
  # @param [String] execute_path The path to the unpacking location
  # @param [FalseClass] delete_archive If true deletes the archive after downloading, by default it is false
  def unpacking_via_7zip(archive_path, execute_path, delete_archive: false)
    File.open(archive_path, 'rb') do |file|
      SevenZipRuby::Reader.open(file) do |szr|
        szr.extract_all execute_path
        FileUtils.rm_rf(archive_path) if delete_archive
      end
      OnlyofficeLoggerHelper.green_log('Unpack completed')
    end
  end

  # Changes the access parameters of the folder and core components, to run on mac and linux
  def change_core_access
    return if @os.include?('windows')

    FileUtils.chmod('+x', Dir.glob("#{Dir.pwd}/#{File.basename(@url, '.7z')}/*"))
  end

  # Writes the date of core creation to the core.data file
  # @param [String] core_data the date of core creation
  def write_core_date(core_data)
    File.write("#{ProjectConfig.core_dir}/core.data", core_data)
  end

  # Reads the previously recorded date of the core creation from the file
  # @return [String] The date of creation of the existing core
  def read_core_data
    return '' unless File.exist?("#{ProjectConfig.core_dir}/core.data")

    File.read("#{ProjectConfig.core_dir}/core.data")
  end

  # Checks that the current core version is up to date
  def check_core_is_up_to_date(core_data)
    existing_core_data = read_core_data
    return unless core_data == existing_core_data && existing_core_data != '' && core_data != ''

    raise(OnlyofficeLoggerHelper.red_log('Core Already up-to-date'))
  end

  # Downloads the core
  def download_core
    FileUtils.rm_rf(ProjectConfig.core_dir)
    OnlyofficeLoggerHelper.green_log("Downloading core\nversion: #{@build}\nOS: #{@os}\nURL: #{@url}")
    File.open(@core_archive, 'wb') do |file|
      file.write(Net::HTTP.get_response(URI(@url)).body)
    end
    OnlyofficeLoggerHelper.green_log('Download completed')
  end

  # checks doubling of the core folder after unpacking, removes for doubling the core folder
  def fix_double_core_folder
    return unless Dir.exist?("#{ProjectConfig.core_dir}core")

    OnlyofficeLoggerHelper.green_log('Fixing double core folder after unpacking')
    Dir["#{ProjectConfig.core_dir}core/*"].each do |file|
      FileUtils.mv(file, ProjectConfig.core_dir)
    end
    FileUtils.rm_rf("#{ProjectConfig.core_dir}core/") if Dir.empty?("#{ProjectConfig.core_dir}core/")
  end

  # Downloading and configures the core
  def getting_core
    core_status = check_core_on_server
    check_core_is_up_to_date(core_status.to_hash['last-modified'][0])
    download_core
    unpacking_via_7zip(@core_archive, ProjectConfig.core_dir, delete_archive: true)
    fix_double_core_folder
    write_core_date(core_status.to_hash['last-modified'][0])
    change_core_access
    XmlActions.new.create_doc_renderer_config
  end
end
