# frozen_string_literal: true

# class for downloading and unpacking core
class CoreActions
  def initialize
    @x2t_config = JSON.load_file("#{Dir.pwd}/config.json")
    @branch = @x2t_config.fetch('branch')
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
    core_status = `curl --head #{@url}`
    return if core_status.split("\r")[0].include?('200 OK')

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

  # Downloading and unpacking the core
  def download_core
    check_core_on_server
    system("curl #{@url} --output #{@core_archive}")
    unpacking_via_7zip(@core_archive, "#{Dir.pwd}/#{File.basename(@url, '.7z')}")
    FileUtils.rm_rf(@core_archive)
    change_core_access
    XmlActions.new.create_doc_renderer_config
    generate_allfonts
  end
end
