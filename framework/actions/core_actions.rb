# frozen_string_literal: true

# class for downloading and unpacking core
class CoreActions
  def initialize
    @x2t_config = JSON.load_file("#{Dir.pwd}/config.json")
    @os = ProjectConfig.host_config[:os]
    @arch = ProjectConfig.host_config[:arch]
    @version = generate_version
    @build = generate_build
    @url = generate_url
    @core_archive = "#{ProjectConfig.tmp_dir}/#{File.basename(@url)}"
  end

  # @return [String] Generated version core for url
  def generate_version
    "v#{@x2t_config.fetch('version')}".sub(/.*\K\..*/, '')
  end

  # @return [String] Generated build for url
  def generate_build
    if @os.include?('windows')
      @x2t_config.fetch('version')
    else
      @x2t_config.fetch('version').sub(/.*\K\./, '-')
    end
  end

  # generates the url for the core download
  def generate_url
    'https://s3.eu-west-1.amazonaws.com/repo-doc-onlyoffice-com/' \
    "#{@os}/core/#{@branch}/#{@version}/#{@build}/#{@arch}/core.7z"
  end

  # Checks if the file exists on the server and checks validity of url
  # @return [String] Response from the server
  def check_core_on_server
    core_status = if @os.include?('windows')
                    `curl --head #{@url} 2>&1`
                  else
                    `curl --head #{@url} 2>/dev/null`
                  end
    raise('get a curl response blank') if core_status == ''
    return core_status if core_status.split("\r")[0].include?('200 OK')

    raise("Core not found, check version and branch settings are correct\nURL: #{@url}\nCurl response:\n#{core_status}")
  end

  # @param [String] archive_path Path to the archive to unpack
  # @param [String] execute_path The path to the unpacking location
  def unpacking_via_7zip(archive_path, execute_path)
    File.open(archive_path, 'rb') do |file|
      SevenZipRuby::Reader.open(file) do |szr|
        szr.extract_all execute_path
      end
    end
  end

  # Changes the access parameters of the folder and core components, to run on mac and linux
  def change_core_access
    return if @os.include?('windows')

    FileUtils.chmod('+x', Dir.glob("#{Dir.pwd}/#{File.basename(@url, '.7z')}/*"))
  end

  # Generate AllFonts.js
  def generate_allfonts
    `#{ProjectConfig.core_dir}/#{ProjectConfig.host_config[:standardtester]}`
  end

  # Finds the date of core creation on the server
  # @param [String] core_status Response from the server
  # @return [String] The date of core creation or a blank line
  def getting_core_date(core_status)
    core_status.split("\n").each do |line|
      next unless line.include?(':')

      key, value = line.split(':')
      return value.strip if key.upcase == 'LAST-MODIFIED'
    end
    ''
  end

  # Writes the date of core creation to the core.data file
  # @param [String] core_data the date of core creation
  def write_core_date_on_file(core_data)
    File.write("#{ProjectConfig.core_dir}/core.data", core_data)
  end

  # Reads the previously recorded date of the core creation from the file
  # @return [String] The date of creation of the existing core
  def read_core_data
    return '' unless File.exist?("#{ProjectConfig.core_dir}/core.data")

    File.read("#{ProjectConfig.core_dir}/core.data")
  end

  # Checks if a core update is required and downloads core
  # @param [String] core_data the date of core creation
  def download_core(core_data)
    existing_core_data = read_core_data
    raise('Core Already up-to-date') if core_data == existing_core_data && existing_core_data != '' && core_data != ''

    FileUtils.rm_rf(ProjectConfig.core_dir)
    p "Downloading core #{@branch}/#{@version}: #{@build} version"
    system("curl #{@url} --output #{@core_archive}")
  end

  # checks doubling of the core folder after unpacking, removes for doubling the core folder
  def fix_double_core_folder
    return unless Dir.exist?("#{ProjectConfig.core_dir}core")

    Dir["#{ProjectConfig.core_dir}core/*"].each do |file|
      FileUtils.mv(file, ProjectConfig.core_dir)
    end
    FileUtils.rm_rf("#{ProjectConfig.core_dir}core/") if Dir.empty?("#{ProjectConfig.core_dir}core/")
  end

  # Downloading and configures the core
  def getting_core
    core_status = check_core_on_server
    core_data = getting_core_date(core_status)
    download_core(core_data)
    unpacking_via_7zip(@core_archive, ProjectConfig.core_dir)
    write_core_date_on_file(core_data)
    FileUtils.rm_rf(@core_archive)
    change_core_access
    XmlActions.new.create_doc_renderer_config
    generate_allfonts
  end
end
